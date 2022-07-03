---@diagnostic disable: unused-local

--- Returns a deep copy of the given object. Non-table objects are copied as
--- in a typical Lua assignment, whereas table objects are copied recursively.
--- Functions are naively copied, so functions in the copied table point to the
--- same functions as those in the input table. Userdata and threads are not
--- copied and will throw an error.
---
---@param orig table Table to copy
---@return table #Table of copied keys and (nested) values.
function vim.deepcopy(orig) end

--- Splits a string at each instance of a separator.
---
---@see |vim.split()|
---@see https://www.lua.org/pil/20.2.html
---@see http://lua-users.org/wiki/StringLibraryTutorial
---
---@param s string String to split
---@param sep string Separator or pattern
---@param plain boolean? If `true` use `sep` literally (passed to string.find)
---@return function #Iterator over the split components
function vim.gsplit(s, sep, plain) end

--- Splits a string at each instance of a separator.
---
--- Examples:
--- ```lua
--- split(":aa::b:", ":")     --> {'','aa','','b',''}
--- split("axaby", "ab?")     --> {'','x','y'}
--- split("x*yz*o", "*", {plain=true})  --> {'x','yz','o'}
--- split("|x|y|z|", "|", {trimempty=true}) --> {'x', 'y', 'z'}
--- ```
---
---@see |vim.gsplit()|
---
---@param s string String to split
---@param sep string Separator or pattern
---@param kwargs? { plain?: boolean, trimempty?: boolean } Keyword arguments:
--- • plain (boolean) If `true` use `sep` literally (passed to string.find)
--- • trimempty (boolean) If `true` remove empty items from the front
---   and back of the list
---@return table #List of split components
function vim.split(s, sep, kwargs) end

--- Return a list of all keys used in a table.
--- However, the order of the return table of keys is not guaranteed.
---
---@see From https://github.com/premake/premake-core/blob/master/src/base/table.lua
---
---@param t table Table
---@return table #List of keys
function vim.tbl_keys(t) end

--- Return a list of all values used in a table.
--- However, the order of the return table of values is not guaranteed.
---
---@param t table Table
---@return table #List of values
function vim.tbl_values(t) end

--- Apply a function to all values of a table.
---
---@param func function|table Function or callable table
---@param t table Table
---@return table #Table of transformed values
function vim.tbl_map(func, t) end

--- Filter a table using a predicate function
---
---@param func function|table Function or callable table
---@param t table Table
---@return table #Table of filtered values
function vim.tbl_filter(func, t) end

--- Checks if a list-like (vector) table contains `value`.
---
---@param t table Table to check
---@param value any Value to compare
---@return boolean #`true` if `t` contains `value`
function vim.tbl_contains(t, value) end

--- Checks if a table is empty.
---
---@see https://github.com/premake/premake-core/blob/master/src/base/table.lua
---
---@param t table Table to check
---@return boolean #`true` if `t` is empty
function vim.tbl_isempty(t) end

--- Merges two or more map-like tables.
---
---@see |extend()|
---
---@param behavior string Decides what to do if a key is found in more than one map:
--- • "error": raise an error
--- • "keep":  use value from the leftmost map
--- • "force": use value from the rightmost map
---@vararg table Two or more map-like tables
---@return table #Merged table
function vim.tbl_extend(behavior, ...) end
