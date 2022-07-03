---@diagnostic disable: unused-local

--- Prompts the user for input
---@param opts { prompt?: string, default?: string, completion?: string, highlight?: function } Additional options. See |input()|
--- • prompt (string|nil) Text of the prompt.
---   Defaults to `Input:`.
--- • default (string|nil) Default reply to the
---   input
--- • completion (string|nil) Specifies type of
---   completion supported for input. Supported
---   types are the same that can be supplied to
---   a user-defined command using the
---   "-complete=" argument. See
---   |:command-completion|
--- • highlight (function) Function that will be
---   used for highlighting user inputs.
---@param on_confirm fun(input?: string): nil Called once the user confirms or abort the input. `input` is what the user typed. `nil` if the user aborted the dialog.
function vim.ui.input(opts, on_confirm) end

--- Prompts the user to pick a single item from a collection of entries
---@generic T
---@param items T[] Arbitrary items
---@param opts { prompt?: string, format_item?: (fun(item: T): string), kind?: string } Additional options
--- • prompt (string|nil) Text of the prompt.
---   Defaults to `Select one of:`
--- • format_item (function item -> text)
---   Function to format an individual item from
---   `items`. Defaults to `tostring`.
--- • kind (string|nil) Arbitrary hint string
---   indicating the item shape. Plugins
---   reimplementing `vim.ui.select` may wish to
---   use this to infer the structure or
---   semantics of `items`, or the context in
---   which select() was called.
---@param on_choice fun(item?: T, idx?: integer): nil Called once the user made a choice. `idx` is the 1-based index of `item` within `items`. `nil` if the user aborted the dialog.
function vim.ui.select(items, opts, on_choice) end
