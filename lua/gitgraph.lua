local M = {
	opts = {
		max_commits = 100,
		show_branch = true,
	},
}

function M.setup(opts)
	M.opts = vim.tbl_deep_extend('force', M.opts, opts or {})
end

function M.open()
	local cmd = "git log --decorate --all --abbrev-commit --date=local --graph --pretty=format:'%h %ad %an %s'"
	local handle = io.popen(cmd)
	if not handle then
		vim.notify('Error', vim.log.levels.ERROR)
		return
	end
	local result = handle:read('*a')
	handle:close()

	local lines = {}
	for line in result:gmatch('[^\r\n]+') do
		table.insert(lines, line)
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_set_option_value('modifiable', true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

return M
