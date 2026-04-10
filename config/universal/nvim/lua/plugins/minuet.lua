return {
  'milanglacier/minuet-ai.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    provider = 'openai_fim_compatible',
    n_completions = 1,
    context_window = 1024,
    provider_options = {
      openai_fim_compatible = {
        api_key = 'TERM',
        name = 'Ollama',
        model = 'qwen-accurate',
        end_point = 'http://localhost:11434/v1//completions',
        stream = true,
        optional = {
          max_tokens = 60,
          temperature = 0, -- Force maximum accuracy
          top_p = 0.9,
          stop = { '<|file_sep|>', '<|endoftext|>' },
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
