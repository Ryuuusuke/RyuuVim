local lspconfig = require("lspconfig")

-- Setup LSP untuk HTML dan VTSLS (TypeScript/JavaScript)
lspconfig.html.setup({})
lspconfig.vtsls.setup({})

-- Mematikan inlay hints di semua buffer
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.lsp.inlay_hint.enable(false, args.buf)
  end,
})
