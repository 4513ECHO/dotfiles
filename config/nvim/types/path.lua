---@diagnostic disable: unused-local
---@diagnostic disable: unused-vararg

---@class Path
---
--- These are passed and accessible
---@field filename string The passed filename
---
--- These are set at start time
---@field _absolute string The cached absolute value of the string
---@field _cwd string The cwd at the time of creating the string
---@field _sep string The separator value for the Path
local Path = {}

---@param self Path
---@param other Path|string
---@return Path
function Path.__div(self, other) end

---@param self Path
---@return string
function Path.__tostring(self) end

---@param self Path
---@param other string
---@return string
function Path.__concat(self, other) end

---@param path unknown
---@return boolean
function Path.is_path(path) end

---@vararg Path|string
---@return Path
function Path:new(...) end

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

---@return boolean
function Path:is_dir() end

---@return boolean
function Path:is_file() end

---@return Path
function Path:parent() end

---@return string[]
function Path:parents() end
