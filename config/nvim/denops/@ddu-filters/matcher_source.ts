import {
  BaseFilter,
  type FilterArguments,
} from "https://deno.land/x/ddu_vim@v3.4.3/base/filter.ts";
import type { DduItem } from "https://deno.land/x/ddu_vim@v3.4.3/types.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.4.0/mod.ts";

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
