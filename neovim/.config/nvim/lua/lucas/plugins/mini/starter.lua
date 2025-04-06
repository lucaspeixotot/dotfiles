return {
    "echasnovski/mini.starter",
    version = "*",
    config = function()
        math.randomseed(os.time())
        local starter = require("mini.starter")
        local header_art =
        [[
 ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄
█  █  █ █       █       █  █ █  █   █  █▄█  █
█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █
█       █   █▄▄▄█  █ █  █       █   █       █
█  ▄    █    ▄▄▄█  █▄█  █       █   █       █
█ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █
█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█
        ]]
        local default_footer = [[
Type query to filter items
<BS> deletes latest character from query
<Esc> resets current query
<Down/Up>, <C-n/p>, <M-j/k> move current item
<CR> executes action of current item
<C-c> closes this buffer]]
        local phrases = {
            "Edit like a pro, code like a maestro—Neovim's where the magic happens.",
            "Neovim: Where keystrokes meet creativity.",
            "Code is poetry, Neovim is the pen.",
            "Transform your workflow, one keystroke at a time with Neovim.",
            "In the world of editors, Neovim is the Zen master.",
            "Neovim: Where efficiency meets elegance.",
            "Your coding sanctuary awaits—enter the realm of Neovim.",
            "Unlock the power of customization and precision with Neovim.",
            "Neovim: The art of coding, redefined.",
            "Craft your code with finesse—Neovim’s got your back."
        }

        local function get_random_phrase()
            local index = math.random(#phrases)
            return phrases[index]
        end
        starter.setup({ header = header_art, footer = default_footer .. "\n\n" .. get_random_phrase() })
        nmap_leader("us", ":lua MiniStarter.open()<cr>", "Open mini starter")
    end,
}
