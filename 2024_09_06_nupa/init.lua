---@diagnostic disable: undefined-global

-- disable noice
---@diagnostic disable-next-line
vim.notify = function(a, c, b)
	-- do nothing
end

-- delay function
local function delay(ms, callback)
	vim.loop.new_timer():start(ms, 0, function()
		vim.schedule(callback)
	end)
end

-- Hide line numbers
vim.opt.number = false
vim.opt.relativenumber = false

-- Set the global variable for Tidal boot file
vim.g.tidal_boot = "BootTidal.hs"

-- Set transparent background colors
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })

-- Disable statusline
vim.opt.laststatus = 0
vim.api.nvim_set_hl(0, "StatusLine", { link = "Normal" })
vim.api.nvim_set_hl(0, "StatusLineNC", { link = "Normal" })
vim.opt.statusline = '%{repeat("─", winwidth("."))}'
vim.opt.ruler = false

-- Hide tabs
vim.opt.showtabline = 0

vim.cmd("edit perfo.tidal")
vim.cmd("edit guide.tidal")
vim.cmd("edit start.scd")
vim.cmd("edit init.lua")

-- Set the cursor to filec buffer
vim.api.nvim_command("buffer start.scd")

local sclang = require("scnvim.sclang")
local sceditor = require("scnvim.editor")
local scwin = require("scnvim.postwin")

-- do not open post window by default
-- sclang.on_init = function() end

sclang.start()
-- Send block with delay
delay(2000, function()
	sceditor.send_block()
	scwin.close()
	vim.api.nvim_command("buffer perfo.tidal")
end)
