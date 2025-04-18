--- @sync entry

local function setup(job, opts) job.open_multi = opts.open_multi end

local function entry(job)
	local h = cx.active.current.hovered
	ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = not job.open_multi })
end

return { entry = entry, setup = setup }
