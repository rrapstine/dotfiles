-- [[ Helix-style navigation ]]
vim.keymap.set("n", "ge", "G", { desc = "Jump to end of file" })
vim.keymap.set("n", "gh", "^", { desc = "Jump to start of line" })
vim.keymap.set("n", "gl", "$", { desc = "Jump to end of line" })
vim.keymap.set("n", "U", "<C-R>", { desc = "Redo" })

-- [[ Centered scrolling ]]
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up, centered" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down, centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result, centered" })

-- [[ Line movement ]]
vim.keymap.set("n", "<C-S-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<C-S-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("i", "<C-S-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<C-S-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<C-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<C-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- [[ Insert helpers ]]
vim.keymap.set("i", ";;", "<Esc>A;<Esc>")
vim.keymap.set("i", ",,", "<Esc>A,<Esc>")

-- [[ Black hole register ]]
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("v", "p", '"_dP')

-- [[ Quit ]]
vim.keymap.set("n", "Q", ":q<CR>")

-- [[ Visual indent (keep selection) ]]
vim.keymap.set("v", ">", ">gv", { desc = "Indent, keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent, keep selection" })

-- [[ Search - keep under <leader>s ]]
vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.files()
end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>s.", function()
  Snacks.picker.recent()
end, { desc = "[S]earch Recent Files" })
vim.keymap.set("n", "<leader>sm", function()
  Snacks.picker.pick("notifications")
end, { desc = "[S]earch [M]essages" })

-- [[ Explorer toggle ]]
vim.keymap.set("n", "\\", "<cmd>Snacks explorer<CR>", { desc = "Toggle Explorer" })

-- [[ Oil ]]
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Oil (parent directory)" })
vim.keymap.set("n", "<leader>-", function()
  require("oil").toggle_float()
end, { desc = "Open Oil (floating)" })

-- [[ Clear whitespace ]]
vim.keymap.set("n", "<leader>cw", function()
  MiniTrailspace.trim()
end, { desc = "[C]lear [w]hitespace" })