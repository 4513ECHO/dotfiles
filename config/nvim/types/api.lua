---@diagnostic disable: unused-local

--- Executes multiple lines of Vimscript at once. It is an alias to
--- |nvim_exec()|, where `output` is set to false. Thus it works identical
--- to |:source|.
---
--- Examples:
--- ```lua
--- vim.cmd('echo 42')
--- vim.cmd([[
---   augroup My_group
---     autocmd!
---     autocmd FileType c setlocal cindent
---   augroup END
--- ]])
--- vim.cmd({ cmd = 'echo', args = { '"foo"' } })
--- ```
---
---@see |ex-cmd-index|
---@param cmd string|table  Command(s) to execute. If a string, executes multiple lines of Vim script at once. In this case, it is an alias to |nvim_exec()|, where `output` is set to false. Thus it works identical to |:source|. If a table, executes a single command. In this case, it is an alias to |nvim_cmd()| where `opts` is empty.
function vim.cmd(cmd) end

--- Prints given arguments in human-readable format.
---
--- Examples:
--- ```lua
--- -- Print highlight group Normal and store it's contents in a variable.
--- local hl_normal = vim.pretty_print(vim.api.nvim_get_hl_by_name("Normal", true))
--- ```
---
---@see |vim.inspect()|
---@generic T
---@param object T
---@return T #given arguments.
function vim.pretty_print(object) end

--- Create or get an autocommand group |autocmd-groups|.
---@param name string The name of the group
---@param opts { clear?: boolean } Dictionary Parameters
--- • clear (bool) optional: defaults to true. Clear
---   existing commands if the group already exists
---   \|autocmd-groups|.
---@return integer #Integer id of the created group.
function vim.api.nvim_create_augroup(name, opts) end

--- Create an |autocommand|
---
--- The API allows for two (mutually exclusive) types of actions
--- to be executed when the autocommand triggers: a callback
--- function (Lua or Vimscript), or a command (like regular
--- autocommands).
---@param event string|string[] The event or events to register this autocommand
---@param opts { group?: string|integer, pattern?: string|string[], buffer?: integer, desc?: string, callback?: function|string, command?: string, once?: boolean, nested?: boolean } Dictionary of autocommand options
--- • group (string|integer) optional: the
---   autocommand group name or id to match against.
--- • pattern (string|array) optional: pattern or
---   patterns to match against |autocmd-pattern|.
--- • buffer (integer) optional: buffer number for
---   buffer local autocommands |autocmd-buflocal|.
---   Cannot be used with {pattern}.
--- • desc (string) optional: description of the
---   autocommand.
--- • callback (function|string) optional: if a
---   string, the name of a Vimscript function to
---   call when this autocommand is triggered.
---   Otherwise, a Lua function which is called when
---   this autocommand is triggered. Cannot be used
---   with {command}. Lua callbacks can return true
---   to delete the autocommand; in addition, they
---   accept a single table argument with the
---   following keys:
---   • id: (number) the autocommand id
---   • event: (string) the name of the event that
---     triggered the autocommand |autocmd-events|
---   • group: (number|nil) the autocommand group id,
---     if it exists
---   • match: (string) the expanded value of
---     |<amatch>|
---   • buf: (number) the expanded value of |<abuf>|
---   • file: (string) the expanded value of
---     |<afile>|
---
--- • command (string) optional: Vim command to
---   execute on event. Cannot be used with
---   {callback}
--- • once (boolean) optional: defaults to false. Run
---   the autocommand only once |autocmd-once|.
--- • nested (boolean) optional: defaults to false.
---   Run nested autocommands |autocmd-nested|.
---@return integer #Integer id of the created autocommand.
function vim.api.nvim_create_autocmd(event, opts) end

--- Find files in runtime directories
---
--- 'name' can contain wildcards. For example
--- nvim_get_runtime_file("colors/*.vim", true) will return all
--- color scheme files. Always use forward slashes (/) in the
--- search pattern for subdirectories regardless of platform.
---
--- It is not an error to not find any files. An empty array is
--- returned then.
---
---@param name string pattern of files to search for
---@param all boolean whether to return all matches or only the first
---@return string[] #list of absolute paths to the found files
function vim.api.nvim_get_runtime_file(name, all) end
