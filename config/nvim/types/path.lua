---@diagnostic disable: unused-local
---@diagnostic disable: unused-vararg

---@class Path
---
---@field filename string The passed filename
---@field _absolute string The cached absolute value of the string
---@field _cwd string The cwd at the time of creating the string
---@field _sep string The separator value for the Path
---@field path { home: string, sep: string, root: function }
local Path = {}

---@param self Path
---@param other Path|string
---@return Path
function Path.__div(self, other) end

---@param self Path
---@param other string
---@return string
function Path.__concat(self, other) end

---@param a unknown
---@return boolean
function Path.is_path(a) end

---@vararg Path|string
---@return Path
function Path:new(...) end

---@return string
function Path:_fs_filename() end

---@return table
function Path:_stat() end

---@return integer
function Path:_st_mode() end

---@vararg Path|string
---@return Path
function Path:joinpath(...) end

---@return string
function Path:absolute() end

---@return boolean
function Path:exists() end

---@return string
function Path:expand() end

---@param cwd string
---@return string
function Path:make_relative(cwd) end

---@param cwd string
---@return string
function Path:normalize(cwd) end

---@param len integer
---@param exclude string[] #TODO: check it out
function Path:shorten(len, exclude) end

---@return boolean
function Path:is_dir() end

---@return boolean
function Path:is_file() end

---@return Path
function Path:parent() end

---@return string[]
function Path:parents() end
