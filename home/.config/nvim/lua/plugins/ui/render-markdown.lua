-- Neovim 0.12+ can store query @capture values as a list of nodes; nvim-treesitter's built-in
-- directives still pass match[id] straight to vim.treesitter.get_node_text(), which expects a
-- single TSNode (see https://github.com/nvim-treesitter/nvim-treesitter/issues/8636). Markdown
-- injections hit that path; render-markdown parses the tree and surfaces the error.
local function patch_nvim_treesitter_query_captures_nvim012()
	if vim.fn.has("nvim-0.12") ~= 1 then
		return
	end
	pcall(require, "nvim-treesitter.query_predicates")

	local query = require("vim.treesitter.query")
	local force_opts = vim.fn.has("nvim-0.10") == 1 and { force = true, all = false } or true

	local html_script_type_languages = {
		["importmap"] = "json",
		["module"] = "javascript",
		["application/ecmascript"] = "javascript",
		["text/ecmascript"] = "javascript",
	}

	local non_filetype_match_injection_language_aliases = {
		ex = "elixir",
		pl = "perl",
		sh = "bash",
		uxn = "uxntal",
		ts = "typescript",
	}

	local function get_parser_from_markdown_info_string(injection_alias)
		local ft = vim.filetype.match({ filename = "a." .. injection_alias })
		return ft or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
	end

	---@param match table
	---@param id string|integer
	---@return TSNode|nil
	local function match_node(match, id)
		local val = match[id]
		if not val then
			return nil
		end
		if type(val) == "table" then
			return val[1]
		end
		return val
	end

	local function valid_args(name, pred, count, strict_count)
		local arg_count = #pred - 1
		if strict_count then
			if arg_count ~= count then
				vim.api.nvim_err_writeln(string.format("%s must have exactly %d arguments", name, count))
				return false
			end
		elseif arg_count < count then
			vim.api.nvim_err_writeln(string.format("%s must have at least %d arguments", name, count))
			return false
		end
		return true
	end

	query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
		if not valid_args("nth?", pred, 2, true) then
			return
		end
		local node = match_node(match, pred[2])
		local n = tonumber(pred[3])
		if node and node:parent() and node:parent():named_child_count() > n then
			return node:parent():named_child(n) == node
		end
		return false
	end, force_opts)

	query.add_predicate("is?", function(match, _pattern, bufnr, pred)
		if not valid_args("is?", pred, 2) then
			return
		end
		local locals = require("nvim-treesitter.locals")
		local node = match_node(match, pred[2])
		local types = { unpack(pred, 3) }
		if not node then
			return true
		end
		local _, _, kind = locals.find_definition(node, bufnr)
		return vim.tbl_contains(types, kind)
	end, force_opts)

	query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
		if not valid_args(pred[1], pred, 2) then
			return
		end
		local node = match_node(match, pred[2])
		local types = { unpack(pred, 3) }
		if not node then
			return true
		end
		return vim.tbl_contains(types, node:type())
	end, force_opts)

	query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
		local node = match_node(match, pred[2])
		if not node then
			return
		end
		local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
		local configured = html_script_type_languages[type_attr_value]
		if configured then
			metadata["injection.language"] = configured
		else
			local parts = vim.split(type_attr_value, "/", {})
			metadata["injection.language"] = parts[#parts]
		end
	end, force_opts)

	query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
		local node = match_node(match, pred[2])
		if not node then
			return
		end
		local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
		metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
	end, force_opts)

	query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
		local id = pred[2]
		local node = match_node(match, id)
		if not node then
			return
		end
		local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
		if not metadata[id] then
			metadata[id] = {}
		end
		metadata[id].text = string.lower(text)
	end, force_opts)
end

return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
	config = function(_, opts)
		patch_nvim_treesitter_query_captures_nvim012()
		require("render-markdown").setup(opts)
	end,
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		link = {
			enabled = true,
			render_modes = false,
			footnote = {
				enabled = true,
				superscript = true,
				prefix = "",
				suffix = "",
			},
			image = "󰥶 ",
			email = "󰀓 ",
			hyperlink = "󰌹 ",
			highlight = "RenderMarkdownLink",
			wiki = {
				icon = "󱗖 ",
				body = function()
					return nil
				end,
				highlight = "RenderMarkdownWikiLink",
			},
			custom = {
				web = { pattern = "^http", icon = "󰖟 " },
				github = { pattern = "github%.com", icon = "󰊤 " },
				gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
				stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
				wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
				youtube = { pattern = "youtube%.com", icon = "󰗃 " },
			},
		},
		callout = {
			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
			abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
			summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
			tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
			info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
			todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
			hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
			success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
			check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
			done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
			question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
			help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
			faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
			attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
			failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
			fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
			missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
			danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
			error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
			bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
			example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
			quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
			cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
		},
		checkbox = {
			enabled = true,
			render_modes = false,
			bullet = false,
			right_pad = 1,
			unchecked = {
				icon = "󰄱 ",
				highlight = "RenderMarkdownUnchecked",
				scope_highlight = nil,
			},
			checked = {
				icon = "󰱒 ",
				highlight = "RenderMarkdownChecked",
				scope_highlight = nil,
			},
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
			},
		},
		bullet = {
			enabled = true,
			render_modes = false,
			icons = { "●", "○", "◆", "◇" },
			ordered_icons = function(ctx)
				local value = vim.trim(ctx.value)
				local index = tonumber(value:sub(1, #value - 1))
				return ("%d."):format(index > 1 and index or ctx.index)
			end,
			left_pad = 0,
			right_pad = 0,
			highlight = "RenderMarkdownBullet",
			scope_highlight = {},
		},
		quote = { icon = "▋" },
		anti_conceal = {
			enabled = true,
			ignore = {
				code_background = true,
				sign = true,
			},
			above = 0,
			below = 0,
		},
	},
}
