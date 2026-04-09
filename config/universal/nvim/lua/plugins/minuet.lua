return {
  'milanglacier/minuet-ai.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    provider = 'openai_compatible',
    n_completions = 1,
    context_window = 1024,
    provider_options = {
      openai_compatible = {
        api_key = 'TERM',
        name = 'Ollama',
        model = 'gemma-2b-fast',
        end_point = 'http://localhost:11434/v1/chat/completions',
        stream = true,
        optional = {
          stop = { '<turn|>' },
          max_tokens = 60,
        },
        template = {
          -- The plugin passes these contexts to the functions automatically
          prompt = function(context_before, context_after, opts)
            return '<|fim_prefix|>' .. context_before .. '<|fim_suffix|>' .. context_after .. '<|fim_middle|>'
          end,
          suffix = function(context_before, context_after, opts)
            return context_after
          end,
        },
      },
    },
  },
}
