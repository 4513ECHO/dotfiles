import {
  BaseFilter,
  type FilterArguments,
} from "jsr:@shougo/ddu-vim@^6.1.0/filter";
import type { DduItem } from "jsr:@shougo/ddu-vim@^6.1.0/types";
import { ensure, is } from "jsr:@core/unknownutil@^4.3.0";

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
  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
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

  params(): Params {
    return {
      ignoredActions: {
        buffer: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        dpp: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mr: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mrr: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
        mrw: ["browse", "copy", "executeSystem", "newDirectory", "newFile"],
      },
    };
  }
}
