import type { Item } from "jsr:@shougo/ddc-vim@^7.0.0/types";
import {
  BaseFilter,
  type FilterArguments,
} from "jsr:@shougo/ddc-vim@^7.0.0/filter";
// based on https://github.com/kuuote/dotvim/blob/92773506/denops/%40ddc-filters/sorter_file.ts

const kindRankDefinition: Record<string, number> = {
  "dir": 1,
  "file": 2,
  "sym=dir": 3,
  "sym=file": 4,
  "symlink": 5,
};
const menuRankDefinition: Record<string, number> = {
  "buf": 1,
  "cwd": 2,
};

// See :help ddc-file-display-rules
function parseMenu(menu?: string): string {
  if (menu === undefined) {
    return "";
  }
  const isRelative = menu.startsWith("/");
  // TODO: handle "^"
  return isRelative ? menu.slice(1, 4) : menu.slice(0, 3);
}

type Params = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Params> {
  filter(args: FilterArguments<Params>): Promise<Item[]> {
    return Promise.resolve(args.items.sort((a, b) => {
      const menuRank = // Compare menu
        (menuRankDefinition[parseMenu(a.menu)] ?? 99) -
        (menuRankDefinition[parseMenu(b.menu)] ?? 99);
      if (menuRank !== 0) {
        return menuRank;
      }

      const kindRank = // Compare kind
        (kindRankDefinition[String(a.kind)] ?? 99) -
        (kindRankDefinition[String(b.kind)] ?? 99);
      if (kindRank !== 0) {
        return kindRank;
      }

      // Return the original order if the kind is the same
      return 0;
    }));
  }

  params(): Params {
    return {};
  }
}
