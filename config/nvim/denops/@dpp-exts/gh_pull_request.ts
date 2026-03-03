import { BaseExt, type BaseExtParams } from "jsr:@shougo/dpp-vim@^2.3.0/ext";
import type { Action, Plugin } from "jsr:@shougo/dpp-vim@^2.3.0/types";
import { ensure, is } from "jsr:@core/unknownutil@^4.3.0";

export type Params = {
  githubAPIToken: string;
};
export type Attrs = {
  pullRequest: number;
};
export type ExtActions<Params extends BaseExtParams> = {
  replace: Action<Params, Plugin[]>;
};

const isInteger = (x: unknown): x is number =>
  typeof x === "number" && Number.isSafeInteger(x) && x > 0;
const isAttrs = is.ObjectOf({ pullRequest: isInteger });
const isResponse = is.ObjectOf({
  head: is.ObjectOf({
    label: is.String,
    ref: is.String,
    repo: is.UnionOf([is.Null, is.ObjectOf({ full_name: is.String })]),
  }),
  merged: is.Boolean,
});

function extractRepo(repo: string): [string, string] | undefined {
  for (
    const prefix of ["https://github.com/", "github.com/", "git@github.com:"]
  ) {
    if (repo.startsWith(prefix)) {
      const [owner, name] = repo.slice(prefix.length).split("/");
      return [owner, name.replace(/\.git$/, "")];
    }
  }
  const splited = repo.split("/");
  if (splited.length === 2) {
    return splited as [string, string];
  }
}

export async function replacePlugin(
  plugin: Plugin,
  extParams?: Params,
): Promise<Plugin> {
  if (!isAttrs(plugin.extAttrs) || !plugin.repo) return plugin;
  const [owner, name] = extractRepo(plugin.repo) ?? [];
  if (!owner || !name) return plugin;

  const response = await fetch(
    `https://api.github.com/repos/${encodeURIComponent(owner)}/${
      encodeURIComponent(name)
    }/pulls/${plugin.extAttrs.pullRequest}`,
    {
      headers: [
        ["Accept", "application/vnd.github+json"],
        ["X-GitHub-Api-Version", "2022-11-28"],
        ...extParams?.githubAPIToken
          ? [["Authorization", `Bearer ${extParams.githubAPIToken}`]]
          : [],
      ],
    },
  );
  if (!response.ok) {
    console.error(
      `Failed to fetch pull request info from ${owner}/${name}#${plugin.extAttrs.pullRequest}: ${response.statusText}`,
    );
    return plugin;
  }
  const { head: { repo, label }, merged } = ensure(
    await response.json(),
    isResponse,
  );
  if (merged) return plugin;
  const [prOwner, rev] = label.split(":");

  return {
    ...plugin,
    repo: "https://github.com/" + (repo?.full_name ?? `${prOwner}/${name}`),
    rev,
  };
}

export class Ext extends BaseExt<Params> {
  override actions: ExtActions<Params> = {
    replace: {
      description:
        "Replace the plugin URL and branch with them of pull request",
      async callback(args) {
        const { plugins } = args.actionParams as { plugins: Plugin[] };
        return await Promise.all(
          plugins.map((plugin) => replacePlugin(plugin, args.extParams)),
        );
      },
    },
  };

  override params(): Params {
    return {
      githubAPIToken: "",
    };
  }
}
