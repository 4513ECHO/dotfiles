#!/usr/bin/env -S gojq -r --yaml-input -f
if $type == "gen" then
  .packages
  | map(
    if .registry? == null then
      .name
    else
      "\(.registry),\(.name)"
    end
    | sub("@.*$"; "")
  )[]
elif $type == "description" then
  .packages[]
  | select(.description? == null)
  | "\(.repo_owner)/\(.repo_name)"
else
  error("Invalid $type: \($type)")
end
