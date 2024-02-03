import {
  BaseFilter,
  type FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.10.3/base/filter.ts";
import type { DduItem } from "https://deno.land/x/ddu_vim@v3.10.3/types.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.17.0/mod.ts";

export type Params = {
  ignoredActions: Record<string, string[]>;
};

const isItem = is.ObjectOf({
  items: is.ArrayOf(is.ObjectOf({
    __sourceName: is.String,
    kind: is.String,
  })),
});
const isActionData = is.ObjectOf({ action: is.String });

export class Filter extends BaseFilter<Params> {
  override filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    if (args.items.length === 0) {
      return Promise.resolve(args.items);
    }
    const { __sourceName, kind } = ensure(args.items.at(0)?.action, isItem)
      .items.at(0)!;
    const ignoredActions = args.filterParams.ignoredActions[__sourceName] ??
      args.filterParams.ignoredActions[kind];
    return Promise.resolve(
      ignoredActions
        ? args.items.filter((item) =>
          !ignoredActions.includes(ensure(item.action, isActionData).action)
        )
        : args.items,
    );
  }

  override params(): Params {
    return {
      ignoredActions: {
        buffer: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        dein: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mr: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mrr: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mrw: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
      },
    };
  }
}
