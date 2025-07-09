return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.git', 'luarc.json', vim.uv.cwd() },
    settings = {
        Lua = {
            telemetry = { enable = false },
            runtime = { version = "LuaJIT" },
            diagnostics = {
                disable = { 'missing-parameters', 'missing-fields' },
            },
        },
    },
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
}
