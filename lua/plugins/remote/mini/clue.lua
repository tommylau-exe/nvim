MiniMisc.safely('later', function()
  local clue = require('mini.clue')

  clue.setup({
    triggers = {
      { mode = 'n', keys = '<leader>' },
      { mode = 'x', keys = '<leader>' },

      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      { mode = 'n', keys = 's' },
      { mode = 'x', keys = 's' },

      { mode = 'n', keys = ']' },
      { mode = 'n', keys = '[' },
      { mode = 'x', keys = ']' },
      { mode = 'x', keys = '[' },

      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },

      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<c-r>' },
      { mode = 'c', keys = '<c-r>' },

      { mode = 'n', keys = '<c-w>' },
      { mode = 'i', keys = '<c-x>' },
    },

    clues = {
      { mode = 'n', keys = '<leader>f', desc = '+find' },
      { mode = 'n', keys = '<leader>g', desc = '+git' },

      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.square_brackets(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },

    window = {
      delay = 300,
      config = { width = 'auto' },
    },
  })
end)
