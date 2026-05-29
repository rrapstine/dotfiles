return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<C-j>"] = { "select_next", "fallback_to_mappings" },
      ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-l>"] = { "snippet_forward", "fallback" },
      ["<C-h>"] = { "snippet_backward", "fallback" },
      ["<C-CR>"] = { "select_and_accept" },
    },
    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      menu = { auto_show = false },
      ghost_text = { enabled = true, show_with_menu = false },
    },
    appearance = { nerd_font_variant = "mono" },
    signature = { enabled = true },
  },
}