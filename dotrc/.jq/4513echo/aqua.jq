module {
  name: "4513echo/aqua",
  version: "0.1.0",
};

def generate:
  .packages
  | map(
    if .registry? == null then
      .name
    else
      "\(.registry),\(.name)"
    end
    | sub("@.*$"; "")
  )[];

def description:
  .packages[]
  | select(.description? == null)
  | "\(.repo_owner)/\(.repo_name)";
