local cmp = require 'cmp'
local lspkind = require'lspkind'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }), -- manually ask for completion
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
		['<S-Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
		['<CR>'] = cmp.mapping.confirm({ select = true}),
		['<C-e>'] = cmp.mapping.abort(),
		['<Esc>'] = cmp.mapping.close(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
	}),
	sources = {
    { name = 'copilot' },
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' },
		{ name = 'path' },
		{ name = 'buffer', keyword_lenth = 4 },
		{ name = 'omni' },
	},
	completion = {
		keyword_length = 1,
		completeopt = "menu,noselect"
	},
	view = {
		entries = 'custom',
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = ({
				nvim_lsp = "[LSP]",
				ultisnips = "[US]",
				nvim_lua = "[Lua]",
				path = "[Path]",
				buffer = "[Buffer]",
				emoji = "[Emoji]",
				omni = "[Omni]",
			}),
      symbol_map = { Copilot = "🚀" },
		}),
	},
  window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
  experimental = {
    ghost_text = true,
  },
})

-- Color settings optional
vim.cmd[[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]]
