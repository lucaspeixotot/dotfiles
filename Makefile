DOT_NVIM_DIR := $(CURDIR)/.config/nvim
BACKUP_NVIM_DIR := $(CURDIR)/.config/backup-nvim
SYS_NVIM_DIR := $(HOME)/.config/nvim


.PHONY: update-nvim

update-nvim:
	@echo 'Updating neovim configuration'
	@echo 'Creating a backup'
	@cp -a $(DOT_NVIM_DIR) $(BACKUP_NVIM_DIR)
	@rm -rf $(DOT_NVIM_DIR)
	@echo 'Copying the new configuration'
	@cp -a $(SYS_NVIM_DIR) $(DOT_NVIM_DIR) && \
		rm -rf $(BACKUP_NVIM_DIR) && \
		rm -rf $(DOT_NVIM_DIR)/reminders && \
		rm -rf $(DOT_NVIM_DIR)/sessions && \
		rm -rf $(DOT_NVIM_DIR)/undodir
	@echo 'Deleted the backup'


