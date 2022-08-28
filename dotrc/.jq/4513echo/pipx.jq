module {
  name: "4513echo/pipx",
  version: "0.1.0"
};

def generate:
  .venvs
  | map_values(.metadata)
  | {
    inject: map_values(
      .injected_packages
      | keys
      | select(.[])
    ),
    install: map(.main_package.package_or_url)
  };

def execute:
  (.install | map("pipx install \(.)")[]),
  (.inject | to_entries | map("pipx inject \(.key) \(.value | join(" "))")[]);
