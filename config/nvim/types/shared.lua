---@diagnostic disable: unused-local

--- Returns a deep copy of the given object. Non-table objects are copied as
--- in a typical Lua assignment, whereas table objects are copied recursively.
--- Functions are naively copied, so functions in the copied table point to the
--- same functions as those in the input table. Userdata and threads are not
--- copied and will throw an error.
---
---@param orig table Table to copy
---@return table Table of copied keys and (nested) values.
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
---@return function Iterator over the split components
function vim.gsplit(s, sep, plain) end

--- Splits a string at each instance of a separator.
---
--- Examples:
--- <pre>
---  split(":aa::b:", ":")     --> {'','aa','','b',''}
---  split("axaby", "ab?")     --> {'','x','y'}
---  split("x*yz*o", "*", {plain=true})  --> {'x','yz','o'}
---  split("|x|y|z|", "|", {trimempty=true}) --> {'x', 'y', 'z'}
--- </pre>
---
---@see |vim.gsplit()|
---
---@param s string String to split
---@param sep string Separator or pattern
---@param kwargs table Keyword arguments:
---       - plain: (boolean) If `true` use `sep` literally (passed to string.find)
---       - trimempty: (boolean) If `true` remove empty items from the front
---         and back of the list
---@return table List of split components
function vim.split(s, sep, kwargs) end
