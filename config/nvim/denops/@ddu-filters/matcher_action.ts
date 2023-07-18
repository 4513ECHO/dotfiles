import {
  BaseFilter,
  type FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.4.1/base/filter.ts";
import type { DduItem } from "https://deno.land/x/ddu_vim@v3.4.1/types.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.2.0/mod.ts";

export type Params = {
  ignoredActions: Record<string, string[]>;
};

const predItem = is
  .ObjectOf({ items: is.ArrayOf(is.ObjectOf({ __sourceName: is.String })) });
const predActionData = is.ObjectOf({ action: is.String });

export class Filter extends BaseFilter<Params> {
  override filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    const { __sourceName } = ensure(args.items.at(0)?.action, predItem)
      .items.at(0)!;
    const ignoredActions = args.filterParams.ignoredActions[__sourceName];
    return Promise.resolve(
      ignoredActions
        ? args.items.filter((item) =>
          !ignoredActions.includes(ensure(item.action, predActionData).action)
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
