;;; elfeed-protocol-freshrss.el --- FreshRSS protocol for elfeed -*- lexical-binding: t; -*-

;; Copyright 2025 Alex Figl-Brick
;; Copyright 2026 Lou Woell

;; Author: Lou Woell <lou@repetitions.de>
;; URL: https://codeberg.org/lou/elfeed-protocol-freshrss
;;
;; Version: 1.2.0
;; Package-Requires: (
;;    (emacs "29.1")
;;    (elfeed "4.0.0")
;;    (elfeed-protocol "1.0.0")
;;    (deferred "0.5.1")
;;    (request "0.3.2")
;;    (request-deferred "0.3.2"))

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see
;; <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Synchronize elfeed with FreshRSS instances using the greader protocol.
;;
;; Possibly works with other implementations of said protocol but that is
;; untested.

;;; Code:

(require 'cl-lib)
(require 'deferred)
(require 'elfeed-protocol)
(require 'request-deferred)
(require 'time-stamp)

(defconst elfeed-protocol-freshrss--greader-id-prefix
  "tag:google.com,2005:reader/item/"
  "Prefix for qualified itemIDs.

 See `elfeed-protocol-freshrss--client-qualify-item-id'")

(defconst elfeed-protocol-freshrss--label-prefix
  "user/-/label/"
  "Prefix for labels/tags/folders.")

(defconst elfeed-protocol-freshrss--api-read-tag
  "user/-/state/com.google/read"
  "The tag in the API that indicates an entry is read.")

(defconst elfeed-protocol-freshrss--api-star-tag
  "user/-/state/com.google/starred"
  "The tag in the API that indicates content is starred.")

(defcustom elfeed-protocol-freshrss-star-tag 'star
  "The elfeed tag that indicates content is starred.")

(defconst elfeed-protocol-freshrss--api-cache
  (make-hash-table :test 'equal)
  "Runtime Cache.")

(defun elfeed-protocol-freshrss--format-log-date (date)
  (format-time-string time-stamp-format date))

(defun elfeed-protocol-freshrss--client-qualify-item-id (id)
  "Qualify the given raw item ID.

The qualified ID is the prefix
`elfeed-protocol-freshrss--greader-id-prefix' followed by the item ID as
an unsigned base 16 number and 0-padded to be always 16 characters long.

See
URL `https://github.com/FreshRSS/FreshRSS/blob/9db1ea42fe5a55620c6e3e6c8b99a59b24cdedb7/p/api/greader.php#L849'
URL `https://feedhq.readthedocs.io/en/latest/api/terminology.html#items'
"
  (format "%s%016x"
          elfeed-protocol-freshrss--greader-id-prefix
          (string-to-number id)))

(defun elfeed-protocol-freshrss-auth (host-url)
  (with-memoization (gethash host-url elfeed-protocol-freshrss--api-cache)
    (let*
        ((proto-id (elfeed-protocol-freshrss--proto-id host-url))
         (user (elfeed-protocol-meta-user proto-id))
         (api-url (elfeed-protocol-meta-prop proto-id :api-url))
         (password (elfeed-protocol-meta-password proto-id))
         (ts (time-convert (current-time) 'integer))
         (token (request-response-data
                 (request (concat api-url "/accounts/ClientLogin")
                   :type "POST"
                   :headers `(("User-Agent" . ,elfeed-user-agent))
                   :data `(("Email" . ,user)
                           ("Passwd" . ,password))
                   :params `((client . "elfeed"))
                   :parser
                   (lambda ()
                     (let ((res '()))
                       (while (not (eobp))
                         (push
                          (split-string (buffer-substring (pos-bol) (pos-eol))
                                        "=")
                          res)
                         (line-move 1))
                       (cadr (assoc "Auth" res #'string=))))
                   :sync t))))
      (list :proto-id proto-id
            :host-url host-url
            :api-url  api-url
            :token    token
            :ts       ts
            :folders  (make-hash-table :test 'equal)
            :labels   (make-hash-table :test 'equal)
            :subfeeds (make-hash-table :test 'equal)))))

(defun elfeed-protocol-freshrss--client-make-request
    (method endpoint expect-output auth params body)
  "Make a METHOD request to ENDPOINT with AUTH.

If EXPECT-OUTPUT, parse as JSON.

AUTH is a plist as returned by `elfeed-protocol-freshrss-auth'.

PARAMS will be sent in query.

BODY will be sent as key=value in body."

  (deferred:$
   (request-deferred
    (concat (plist-get auth :api-url) endpoint)
    :type method
    :params (append params
                    `((client . "elfeed"))
                    (when expect-output '((output . json))))
    :data body
    :headers `(("Authorization" . ,(concat "GoogleLogin auth="
                                           (plist-get auth :token)))
               ("User-Agent" . ,elfeed-user-agent))
    :parser (if expect-output
                (lambda ()
                  (let ((json-array-type 'list))
                    (json-read)))
              (lambda () nil)))
   (deferred:nextc
    it
    (lambda (response)
      (elfeed-log 'debug "elfeed-protocol-freshrss: request url: %s"
                  (request-response-url response))
      (request-response-data response)))))

(defun elfeed-protocol-freshrss--client-get-tags (auth)
  "Get all tags for the user using AUTH.

The return value has one top-level field: \\='subscription"
  (elfeed-protocol-freshrss--client-make-request
   "GET" "/reader/api/0/tag/list"
   t auth nil nil))

(defun elfeed-protocol-freshrss--client-get-all-subscriptions (auth)
  "Get all subscriptions for the user using AUTH."
  (elfeed-protocol-freshrss--client-make-request
   "GET" "/reader/api/0/subscription/list"
   t auth nil nil))

(defun elfeed-protocol-freshrss--client-get-contents (auth newer-than url)
  "Get contents of items NEWER-THAN.

This function calls the generic /stream/contents endpoint.

See

URL `https://github.com/FreshRSS/FreshRSS/blob/d257166acbfc36a40fb845134a25dc8e8b633b39/p/api/greader.php#L683'
URL `https://code.google.com/archive/p/pyrfeed/wikis/GoogleReaderAPI.wiki'
URL `https://web.archive.org/web/20210126115837/https://blog.martindoms.com/2009/10/16/using-the-google-reader-api-part-2#feed'
"
  (elfeed-protocol-freshrss--client-make-request
   "GET"
   (concat "/reader/api/0/stream/contents" (or url ""))
   t
   auth
   `((ot . ,newer-than)
     (r . n)
     (n .  1000))
   nil))


(defun elfeed-protocol-freshrss--client-get-contents-all (auth newer-than url)
  "Get ALL contents items via pagination.

Follows continuation tokens returned by the API until all items are
fetched, or until the safety limit of 50 pages is reached."
  (let ((all-items '())
        (page-count 0))
    (cl-labels
        ((fetch-page (continuation)
           (deferred:nextc
            (elfeed-protocol-freshrss--client-make-request
             "GET"
             (concat "/reader/api/0/stream/contents" (or url ""))
             t auth
             (append `((ot . ,newer-than)
                       (r . n)
                       (n .  1000))
                     (when continuation `((c . ,continuation))))
             nil)
            (lambda (data)
              (cl-incf page-count)
              (let ((new-items (alist-get 'items data)))
                (setq all-items (append all-items new-items))
                (elfeed-log 'debug
                 "elfeed-protocol-freshrss: contents page %s: %s items (total: %s)"
                 page-count (length new-items) (length all-items))
                (if-let ((cont (alist-get 'continuation data))
                         ((< page-count 50)))
                    (fetch-page cont)
                  `((items . ,all-items))))))))
      (fetch-page nil))))
(defun elfeed-protocol-freshrss--client-get-item-contents
    (auth item-ids newer-than)
  "Get item details for ITEM-IDS using AUTH.

 ITEM-IDS must already be qualified, such as by calling
`elfeed-protocol-freshrss-client-qualify-item-ids'."
  (if (and item-ids (listp item-ids))
      (elfeed-protocol-freshrss--client-make-request
       "POST"
       "/reader/api/0/stream/items/contents"
       t
      auth
       `((ot . ,newer-than))
       (mapcar (lambda (x) (cons 'i x)) item-ids))
    (signal 'wrong-type-argument "item-ids must be non-empty list")))

(defun elfeed-protocol-freshrss--client-get-item-ids
    (auth include exclude)
  "Get all items newer than NEWER-THAN (seconds from epoch) using AUTH.

The return value has two top-level fields: \\='itemRefs and
\\='continuation.

URL `https://web.archive.org/web/20130708105542/http://undoc.in/stream.html#items'
URL `https://github.com/FreshRSS/FreshRSS/blob/d257166acbfc36a40fb845134a25dc8e8b633b39/p/api/greader.php#L765'
"
  (elfeed-protocol-freshrss--client-make-request
   "GET"
   "/reader/api/0/stream/items/ids"
   t
   auth
   `((s  . ,include)
     (xt . ,exclude)
     (r  . n)
     (n  . 10000))
   nil))


(defun elfeed-protocol-freshrss--client-get-item-ids-all (auth include exclude)
  "Get ALL item IDs via pagination.

Follows continuation tokens returned by the API until all IDs are
fetched, or until the safety limit of 50 pages is reached."
  (let ((all-item-refs '())
        (page-count 0))
    (cl-labels
        ((fetch-page (continuation)
           (deferred:nextc
            (elfeed-protocol-freshrss--client-make-request
             "GET" "/reader/api/0/stream/items/ids" t auth
             (append `((s  . ,include)
                       (xt . ,exclude)
                       (r  . n)
                       (n  . 10000))
                     (when continuation `((c . ,continuation))))
             nil)
            (lambda (data)
              (cl-incf page-count)
              (let ((new-ids (alist-get 'itemRefs data)))
                (setq all-item-refs (append all-item-refs new-ids))
                (elfeed-log 'debug
                 "elfeed-protocol-freshrss: item-ids page %s: %s ids (total: %s)"
                 page-count (length new-ids) (length all-item-refs))
                (if-let ((cont (alist-get 'continuation data))
                         ((< page-count 50)))
                    (fetch-page cont)
                  `((itemRefs . ,all-item-refs))))))))
      (fetch-page nil))))
(defun elfeed-protocol-freshrss--client-edit-tag (auth ids tag)
  "Edit the IDS by applying TAG, using AUTH for authentication.

TAG should be in the format ([ar] . TAG-STRING)."
  (elfeed-protocol-freshrss--client-make-request
   "POST"
   "/reader/api/0/edit-tag"
   nil
   auth
   nil
   (cons tag (mapcar (lambda (id) `(i . ,id)) ids))))

(defun elfeed-protocol-freshrss--client-mark-ids-read (auth ids)
  "Mark the given IDS as read, using AUTH for authentication."
  (elfeed-protocol-freshrss--client-edit-tag
   auth ids `(a . ,elfeed-protocol-freshrss--api-read-tag)))

(defun elfeed-protocol-freshrss--client-mark-ids-unread (auth ids)
  "Mark the given IDS as unread, using AUTH for authentication."
  (elfeed-protocol-freshrss--client-edit-tag
   auth ids `(r . ,elfeed-protocol-freshrss--api-read-tag)))

(defun elfeed-protocol-freshrss--client-mark-ids-starred (auth ids)
  "Mark the given IDS as starred, using AUTH for authentication."
  (elfeed-protocol-freshrss--client-edit-tag
   auth ids `(a . ,elfeed-protocol-freshrss--api-star-tag)))

(defun elfeed-protocol-freshrss--client-mark-ids-unstarred (auth ids)
  "Mark the given IDS as unstarred, using AUTH for authentication."
  (elfeed-protocol-freshrss--client-edit-tag
   auth ids `(r . ,elfeed-protocol-freshrss--api-star-tag)))

(defun elfeed-protocol-freshrss--proto-id (host-url)
  "Get Freshrss protocol ID for given HOST-URL."
  (elfeed-protocol-id "freshrss" host-url))

(defun elfeed-protocol-freshrss--set-update-mark (proto-id mark)
  "Set last update MARK to elfeed db. PROTO-ID is the target protocol feed id."
  (elfeed-log 'debug "elfeed-freshrss: Setting update mark for proto %s to %s"
              proto-id
              (if (= -1 mark)
                  mark
                (elfeed-protocol-freshrss--format-log-date mark)))
  (elfeed-protocol-set-db-feed-meta proto-id :last-crawl-time mark))

(defun elfeed-protocol-freshrss--get-update-mark (proto-id)
  "Get the last update mark for PROTO-ID."
  (or (elfeed-protocol-get-db-feed-meta proto-id :last-crawl-time) -1))

(defun elfeed-protocol-freshrss--split-and-call-in-parallel (auth func things)
  "Split THINGS into groups of 100 and call FUNC in parallel for each
group, using AUTH for authentication.

FUNC must accept two arguments: (AUTH LIST)."
  (deferred:parallel
   (mapcar
    (lambda (sub-things)
      (funcall func auth sub-things))
    (seq-partition things 100))))

(defun elfeed-protocol-freshrss--sync-pending-ids (host-url)
  "Sync pending read/unread/starred/unstarred entry states to HOST-URL."
  (let* ((auth (elfeed-protocol-freshrss-auth host-url))
         (proto-id (plist-get auth :proto-id))
         (pending-read-ids (elfeed-protocol-get-pending-ids
                            proto-id :pending-read))
         (pending-unread-ids (elfeed-protocol-get-pending-ids
                              proto-id :pending-unread))
         (pending-starred-ids (elfeed-protocol-get-pending-ids
                               proto-id :pending-starred))
         (pending-unstarred-ids (elfeed-protocol-get-pending-ids
                                 proto-id :pending-unstarred)))
    (deferred:$
     (deferred:parallel
      (elfeed-protocol-freshrss--split-and-call-in-parallel
       auth #'elfeed-protocol-freshrss--client-mark-ids-read pending-read-ids)
      (elfeed-protocol-freshrss--split-and-call-in-parallel
       auth #'elfeed-protocol-freshrss--client-mark-ids-unread
       pending-unread-ids)
      (elfeed-protocol-freshrss--split-and-call-in-parallel
       auth #'elfeed-protocol-freshrss--client-mark-ids-starred
       pending-starred-ids)
      (elfeed-protocol-freshrss--split-and-call-in-parallel
       auth #'elfeed-protocol-freshrss--client-mark-ids-unstarred
       pending-unstarred-ids))

     (deferred:nextc
      it
      (lambda (&rest _)
        (elfeed-protocol-clean-pending-ids proto-id)))

     (deferred:error
      it
      (lambda (e)
        (elfeed-log
         'warn
         "elfeed-protocol-freshrss: failed to sync pending IDs due to: %s"
         e))))))

(defun elfeed-protocol-freshrss--map-json-to-entry (auth item-content-json)
  "Convert the given ITEM-CONTENT-JSON to an elfeed entry."

  (pcase-let* (((map :proto-id :host-url :labels :subfeeds) auth)
               ((map id title canonical published updated
                     summary categories origin)
                item-content-json)
               ((map content)  summary)
               ((map streamId) origin)
               (feed-id (elfeed-protocol-format-subfeed-id
                         proto-id
                         (gethash streamId subfeeds
                                  elfeed-protocol-unknown-feed-url)))
               (folder (elfeed-meta (elfeed-db-get-feed feed-id)
                                    :freshrss.folders))
               (tags (if (member elfeed-protocol-freshrss--api-read-tag
                                 categories)
                         (remove 'unread elfeed-initial-tags)
                       elfeed-initial-tags))
               (tags (append tags folder
                             (mapcar (lambda (x) (gethash x labels))
                                     categories)))
               (tags (remq nil tags)))
    (elfeed-entry--create
     :id (cons host-url id)
     :title (elfeed-cleanup title)
     :link (elfeed-cleanup (alist-get 'href (car canonical)))
     :date (elfeed-new-date-for-entry nil (or published updated))
     :content content
     :content-type 'html
     :tags tags
     :feed-id feed-id
     :meta (list
            :protocol-id proto-id
            :id id))))

(defun elfeed-protocol-freshrss--set-feed-data (auth feed-alist)
  "Set the correct data for a feed in the database."
  (pcase-let*
      (((map ('id api-id) url title categories) feed-alist)
       ((map :proto-id :folders :subfeeds) auth)
       (feed-id (elfeed-protocol-format-subfeed-id proto-id url))
       (feed-db (elfeed-db-get-feed feed-id))
       (folders (cl-loop for c in categories collect
                         (pcase-let* (((map id) c))
                           (gethash id folders)))))

    (setf (elfeed-feed-url   feed-db) feed-id
          (elfeed-feed-title feed-db) title
          (elfeed-meta feed-db :freshrss.folders) folders
          (elfeed-meta feed-db :freshrss.api-id) api-id)

    (puthash api-id url subfeeds)))

(defun elfeed-protocol-freshrss--seed-feed-db (auth)
  (deferred:$
   (elfeed-protocol-freshrss--client-get-all-subscriptions auth)
   (deferred:nextc
    it
    (lambda (data)
      (pcase-let (((map subscriptions) data)
                  ((map :subfeeds) auth))
        (elfeed-log 'debug "elfeed-protocol-freshrss: seeding feed db.")
        (clrhash subfeeds)
        (dolist (feed subscriptions)
          (elfeed-protocol-freshrss--set-feed-data auth feed)))))
   (deferred:error
    it
    (lambda (e)
      (elfeed-log
       'error "elfeed-protocol-freshrss: Feed Sync Error: %s" e)))))

(defun elfeed-protocol-freshrss--sync-label-db (auth)
  (deferred:$
   (elfeed-protocol-freshrss--client-get-tags auth)
   (deferred:nextc
    it
    (lambda (categories)
      (elfeed-log 'debug "elfeed-protocol-freshrss: parsing-tags")
      (pcase-let (((map tags) categories)
                  ((map :folders :labels) auth))
        (dolist (tag tags)

          (pcase-let* (((map id type) tag)
                       (name (string-remove-prefix
                              elfeed-protocol-freshrss--label-prefix id)))
            (pcase type
              ("tag"    (puthash id (intern name) labels))
              ("folder" (puthash id (intern name) folders))))))))

   (deferred:error
    it
    (lambda (e)
      (elfeed-log 'error "elfeed-protocol-freshrss: Label Sync Error: %s" e)))))

(defun elfeed-protocol-freshrss--sync-content
    (auth start callback &optional subfeed)

  (deferred:$
   (elfeed-protocol-freshrss--client-get-contents-all auth start subfeed)
   (deferred:nextc
    it
    (lambda (content-data)
      (pcase-let*
          (((map :proto-id) auth)
           ((map items) content-data)
           (entries (mapcar (lambda (item-json)
                              (elfeed-protocol-freshrss--map-json-to-entry
                               auth item-json))
                            items)))

        (elfeed-db-add entries)

        (elfeed-log
         'info "elfeed-protocol-freshrss: Synced %s items" (length entries))

        (elfeed-protocol-freshrss--set-update-mark
         proto-id (time-convert (current-time) 'integer))

        (when callback
          (funcall callback entries)))))
   (deferred:error
    it
    (lambda (e)
      (elfeed-log 'error "elfeed-protocol-freshrss: Content Sync Error: %s" e)))))

(defun elfeed-protocol-freshrss--sync-read-state (auth)
  (deferred:$

   ;; get 10 000 most recent unread ids.
   (elfeed-protocol-freshrss--client-get-item-ids-all
    auth nil elfeed-protocol-freshrss--api-read-tag)
   (deferred:nextc
    it
    (lambda (ids)
      (elfeed-log
       'debug "elfeed-protocol-freshrss: unread ids: %s"
       (length (alist-get 'itemRefs ids)))

      (cl-flet
          ((normalize (id)
             (pcase-let (((map :host-url) auth)
                         (id (cdar id)))
               (cons host-url
                     (elfeed-protocol-freshrss--client-qualify-item-id
                      id)))))

        (let* ((ids (alist-get 'itemRefs ids))
               (ids (mapcar #'normalize ids))
               ;; get all ids in elfeed db
               (hash-keys (hash-table-keys elfeed-db-entries))

               ;; assume all ids not in IDS are read
               (diff (cl-set-difference
                      hash-keys ids
                      :test #'equal))

               ;; disable pre- [un]tag functions
               (elfeed-untag-hook
                (remove 'elfeed-protocol-on-tag-remove elfeed-untag-hook))
               (elfeed-tag-hook
                (remove 'elfeed-protocol-on-tag-remove elfeed-tag-hook))

               ;; mark as read
               (read (elfeed-untag (mapcar #'elfeed-db-get-entry diff)
                                   'unread))

               ;; mark as unread
               (unread (elfeed-tag (remq nil (mapcar #'elfeed-db-get-entry ids))
                                   'unread)))

          (elfeed-log
           'debug "elfeed-protocol-freshrss: hash-keys: %s" (length hash-keys))
          (elfeed-log
           'debug "elfeed-protocol-freshrss: read ids: %s"  (length diff))
          (elfeed-log
           'info "elfeed-protocol-freshrss: marked %s entries as read"
           (length read))
          (elfeed-log
           'info "elfeed-protocol-freshrss: marked %s entries as unread"
           (length unread))))))
   (deferred:error
    it
    (lambda (e)
      (elfeed-log 'error "elfeed-protocol-freshrss: Read State Sync Error: %s" e)))))

(defun elfeed-protocol-freshrss--sync-fav-state (auth)
  (deferred:$
   (elfeed-protocol-freshrss--client-get-item-ids-all
    auth elfeed-protocol-freshrss--api-star-tag nil)
   (deferred:nextc
    it
    (lambda (ids)
      (elfeed-log
       'debug "elfeed-protocol-freshrss: starred ids: %s"
       (length (alist-get 'itemRefs ids)))

      (cl-flet
          ((normalize (id)
             (cons (plist-get auth :host-url)
                   (elfeed-protocol-freshrss--client-qualify-item-id
                    (cdar id)))))
        (let* ((ids (alist-get 'itemRefs ids))
               (ids (mapcar #'normalize ids))
               (elfeed-untag-hook
                (remove 'elfeed-protocol-on-tag-remove elfeed-untag-hook))
               (elfeed-tag-hook
                (remove 'elfeed-protocol-on-tag-remove elfeed-tag-hook))
               (tag nil)
               (untag nil))
          (elfeed-db-visit (entry)
            (if (member (elfeed-entry-id entry) ids)
                (push entry tag)
              (push entry untag)))
          (elfeed-tag tag elfeed-protocol-freshrss-star-tag)
          (elfeed-untag untag elfeed-protocol-freshrss-star-tag)
          (elfeed-log
           'info "elfeed-protocol-freshrss: %s favourite entries."
           (length ids))))))
   (deferred:error
    it
    (lambda (e) (elfeed-log 'error "elfeed-protocol-freshrss: Fav State Sync Error: %s" e)))))

(defun elfeed-protocol-freshrss--do-update (host-url action start callback)
  "Fetch entries for HOST-URL and update database.
If CALLBACK is provided, also call it with the entries.

ACTION can be either \\='init, \\='update or (\\='subfeed SUBFEED-URL).

If ACTION is \\='init, START is ignored, and the most recent entries are
fetched.

If ACTION is \\='update, we fetch the next entries starting at START."
  (let* ((auth (elfeed-protocol-freshrss-auth host-url))
         (proto-id (plist-get auth :proto-id)))

    ;; Mostly following this strategy:
    ;; URL `https://github.com/FreshRSS/FreshRSS/issues/2566#issuecomment-541317776'

    (when (eq action 'init)
      (elfeed-protocol-freshrss--set-update-mark proto-id -1)
      (elfeed-protocol-clean-pending-ids proto-id)
      (elfeed-protocol-add-unknown-feed proto-id))

    (elfeed-log 'debug "elfeed-protocol-freshrss: retrieve newer than: %s"
                (elfeed-protocol-freshrss--format-log-date start))

    (deferred:$
     ;; Get Labels/Folders
     (elfeed-protocol-freshrss--sync-label-db auth)

     ;; Get Feeds
     (deferred:nextc
      it (lambda (_) (elfeed-protocol-freshrss--seed-feed-db auth)))

     ;; Get 1000 articles since START
     (deferred:nextc
      it (lambda (_) (elfeed-protocol-freshrss--sync-content
                 auth start callback
                 (pcase action
                   ('update nil)
                   ('init nil)
                   (`(subfeed . ,feed-id) feed-id)))))

     ;; sync read state with server
     (deferred:nextc
      it (lambda (_)
           (when (member action '(init update))
             (elfeed-protocol-freshrss--sync-read-state auth))))

     ;; get 1000 most recent favourites
     (deferred:nextc
      it (lambda (_)
           (when (member action '(init update))
             (elfeed-protocol-freshrss--sync-content
              auth nil callback
              (concat "/" elfeed-protocol-freshrss--api-star-tag)))))

     ;; sync fav state
     (deferred:nextc
      it (lambda (_)
           (when (member action '(init update))
             (elfeed-protocol-freshrss--sync-fav-state auth)))))))

(defun elfeed-protocol-freshrss-update (host-or-subfeed-url &optional callback)
  "Update the entries from Freshrss."
  (interactive)
  (let* ((host-url (elfeed-protocol-host-url host-or-subfeed-url))
         (subfeed-url (elfeed-protocol-subfeed-url host-or-subfeed-url))
         (proto-id (elfeed-protocol-freshrss--proto-id host-url))
         (last-crawl-timestamp
          (elfeed-protocol-freshrss--get-update-mark proto-id))
         (init? (not (and last-crawl-timestamp (> last-crawl-timestamp 0))))
         (subfeed-url
          (when (and subfeed-url (not init?))
            (elfeed-log 'info "elfeed-protocol-freshrss: Updating subfeed: %s"
                        subfeed-url)
            (let* ((feed-id (elfeed-protocol-format-subfeed-id proto-id
                                                               subfeed-url))
                   (subfeed (elfeed-db-get-feed feed-id)))
              (concat "/" (elfeed-meta subfeed :freshrss.api-id))))))

    (deferred:$
     (elfeed-protocol-freshrss--sync-pending-ids host-url)
     (deferred:nextc
      it (lambda (_) (elfeed-protocol-freshrss--do-update
                 host-url
                 (cond (subfeed-url `(subfeed . ,subfeed-url))
                       (init? 'init)
                       (t 'update))
                 (when (and (not subfeed-url)
                            (not init?))
                   (1+ last-crawl-timestamp))
                 callback)))
     (deferred:error
      it
      (lambda (e) (elfeed-log 'error "elfeed-protocol-freshrss: Error: %s" e))))))

(defun elfeed-protocol-freshrss-entry-p (host-url entry)
  "Check if specific ENTRY is from Freshrss."
  (string= (elfeed-protocol-entry-protocol-id entry)
           (elfeed-protocol-freshrss--proto-id host-url)))

(defun elfeed-protocol-freshrss--append-pending-id (host-url entry tag action)
  "Append read/unread/starred/unstarred ids to pending list.

ENTRY is the target entry object. TAG is the action tag, for example
`unread and `elfeed-protocol-freshrss-star-tag', ACTION could be add or
remove."

  (when (elfeed-protocol-freshrss-entry-p host-url entry)
    (let* ((proto-id (elfeed-protocol-freshrss--proto-id host-url))
           (id (elfeed-meta entry :id)))
      (cond
       ((eq action 'add)
        (cond
         ((eq tag 'unread)
          (elfeed-protocol-append-pending-ids proto-id
                                              :pending-unread
                                              (list id))
          (elfeed-protocol-remove-pending-ids proto-id
                                              :pending-read
                                              (list id)))
         ((eq tag elfeed-protocol-freshrss-star-tag)
          (elfeed-protocol-append-pending-ids proto-id
                                              :pending-starred
                                              (list id))
          (elfeed-protocol-remove-pending-ids proto-id
                                              :pending-unstarred
                                              (list id)))))
       ((eq action 'remove)
        (cond
         ((eq tag 'unread)
          (elfeed-protocol-append-pending-ids proto-id
                                              :pending-read
                                              (list id))
          (elfeed-protocol-remove-pending-ids proto-id
                                              :pending-unread
                                              (list id)))
         ((eq tag elfeed-protocol-freshrss-star-tag)
          (elfeed-protocol-append-pending-ids proto-id
                                              :pending-unstarred
                                              (list id))
          (elfeed-protocol-remove-pending-ids proto-id
                                              :pending-starred
                                              (list id)))))))))

(defun elfeed-protocol-freshrss-pre-tag (host-url entries &rest tags)
  "Sync unread and starred states before tags added.
ENTRIES is the target entry objects.  TAGS is the tags are adding now."
  (dolist (tag tags)
    (cl-loop for entry in entries
             unless (elfeed-tagged-p tag entry)
             do (elfeed-protocol-freshrss--append-pending-id host-url
                                                             entry
                                                             tag
                                                             'add)))
  (unless elfeed-protocol-lazy-sync
    (elfeed-protocol-freshrss--sync-pending-ids host-url)))

(defun elfeed-protocol-freshrss-pre-untag (host-url entries &rest tags)
  "Sync unread and starred states before tags removed.
ENTRIES is the target entry objects.  TAGS is the tags are adding now."
  (dolist (tag tags)
    (cl-loop for entry in entries
             when (elfeed-tagged-p tag entry)
             do (elfeed-protocol-freshrss--append-pending-id host-url
                                                             entry
                                                             tag
                                                             'remove)))
  (unless elfeed-protocol-lazy-sync
    (elfeed-protocol-freshrss--sync-pending-ids host-url)))

(defun elfeed-protocol-freshrss--autotags (f url-or-feed)
  (append
   (let ((feed (cl-typecase url-or-feed
                 (elfeed-feed url-or-feed)
                 (string (gethash url-or-feed elfeed-db-feeds)))))
     (when feed (elfeed-meta feed :freshrss.folders)))
   (funcall f url-or-feed)))

(defun elfeed-protocol-freshrss--feed-list (f &optional all)
  "Advice for `elfeed-feed-list' to include subfeeds if ALL is non-nil.

This allows to update subfeeds via `elfeed-update-feed'."
  (append (when all (hash-table-keys elfeed-db-feeds))
          (funcall f all)))

;; Probably should be a minor mode tbh.
(defun elfeed-protocol-freshrss-register-protocol ()
  "Register and initialize the \"freshrss\" elfeed protocol handler."

  (advice-add 'elfeed-feed-autotags :around
              #'elfeed-protocol-freshrss--autotags)
  (advice-add 'elfeed-feed-list :around
              #'elfeed-protocol-freshrss--feed-list)

  (elfeed-protocol-register
   "freshrss"
   (list :update    'elfeed-protocol-freshrss-update
         :pre-tag   'elfeed-protocol-freshrss-pre-tag
         :pre-untag 'elfeed-protocol-freshrss-pre-untag)))

(defun elfeed-protocol-freshrss-unregister-protocol ()
  "Unregister the \"freshrss\" elfeed protocol handler.

Also removes advices."

  (advice-remove 'elfeed-feed-autotags #'elfeed-protocol-freshrss--autotags)
  (advice-remove 'elfeed-feed-list #'elfeed-protocol-freshrss--feed-list)

  (elfeed-protocol-unregister "freshrss"))

(provide 'elfeed-protocol-freshrss)

;;; elfeed-protocol-freshrss.el ends here
