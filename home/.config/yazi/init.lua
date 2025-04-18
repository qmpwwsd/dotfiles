-- init.lua

-- Created: 04/09/24

-- reconfigure status line with modified time

-- return modified time
function Status:mtime()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span('')
	end
	local time = h.cha.modified
	return ui.Span(time and os.date('%m-%d-%y %H:%M ', time // 1) or '')
end

-- display status line
function Status:render(area)
	self.area = area

	local left = ui.Line({ self:mode(), self:name() })
	local right = ui.Line({ self:mtime(), self:size(), self:position() })
	return {
		ui.Paragraph(area, { left }),
		ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
		table.unpack(Progress:render(area, right:width())),
	}
end

-- end reconfigure status line

-- add symlink to status line for links

-- get host name and set width depending on machine
local function GetHostname()
	local f = io.popen('/bin/hostname')
	local hostname = f:read('*a') or ''
	f:close()
	return string.gsub(hostname, '\n$', '')
end
local Host = GetHostname()

local linked_width = 0
if Host == 'CB' then
	linked_width = 55
elseif Host == 'LM' then
	linked_width = 65
end

-- add symlink to status line

function Status:name()
	local h = cx.active.current.hovered
	if not h then
		return ui.Span('')
	end

	-- if there's a link format and display it
	local linked = ''
	if h.link_to ~= nil then
		linked = ' -> ' .. tostring(h.link_to)
		linked = ' ' .. h.name .. linked
		-- adjust for width depending on which machine
		linked = string.sub(linked, 1, linked_width) .. '...'
		return ui.Span(linked)
		-- otherwise just the name
	else
		return ui.Span(' ' .. h.name)
	end
end

-- change layout of modeline mtime format with year last

if not Folder then Folder = {} end
function Folder:linemode(area, files)
	local mode = cx.active.conf.linemode
	if mode == 'none' then
		return {}
	end

	local lines = {}
	-- loop through files - construct each line
	for _, f in ipairs(files) do
		local spans = { ui.Span(' ') }
		if mode == 'size' then
			local size = f:size()
			spans[#spans + 1] = ui.Span(size and ya.readable_size(size) or '')
		elseif mode == 'mtime' then
			local time = f.cha.modified
			-- changed to put year at the end
			spans[#spans + 1] = ui.Span(time and os.date('%m-%d-%y %H:%M', time // 1) or '')
		elseif mode == 'permissions' then
			spans[#spans + 1] = ui.Span(f.cha:permissions() or '')
		end

		spans[#spans + 1] = ui.Span(' ')
		lines[#lines + 1] = ui.Line(spans)
	end
	return ui.Paragraph(area, lines):align(ui.Paragraph.RIGHT)
end

-- integrate yazi cwd changes into zoxide
require("zoxide"):setup {
	update_db = true,
}

require("git"):setup()
require("full-border"):setup()
require("omp"):setup({ config = "~/.config/zsh/themes/tokyonight.omp.toml"})
