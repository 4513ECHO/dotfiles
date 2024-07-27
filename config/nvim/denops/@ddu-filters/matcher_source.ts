import {
  BaseFilter,
  type FilterArguments,
} from "jsr:@shougo/ddu-vim@^5.0.0/filter";
import type { DduItem } from "jsr:@shougo/ddu-vim@^5.0.0/types";
import { ensure, is } from "jsr:@core/unknownutil@^3.18.1";

export type Params = {
  ignoredSources: string[];
};

export class Filter extends BaseFilter<Params> {
  override filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    return Promise.resolve(
      args.items.filter((item) =>
        !args.filterParams.ignoredSources.includes(
          ensure(item.action, is.ObjectOf({ name: is.String })).name,
        )
      ),
    );
  }

  override params(): Params {
    return {
      ignoredSources: ["action", "file_external", "custom-list", "ddc"],
    };
  }
}
