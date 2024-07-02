import {
  BaseFilter,
  type FilterArguments,
  type OnInitArguments,
} from "https://deno.land/x/ddu_vim@v3.10.3/base/filter.ts";
import type { DduItem } from "https://deno.land/x/ddu_vim@v3.10.3/types.ts";
import { ensure, is } from "jsr:@core/unknownutil@^3.18.1";

export type Params = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Params> {
  #colorschemes: string[] = [];

  override async onInit(args: OnInitArguments<Params>): Promise<void> {
    this.#colorschemes = Object.keys(
      ensure(
        await args.denops.call("user#colorscheme#get"),
        is.RecordOf(is.Record),
      ),
    );
  }

  override filter(args: FilterArguments<Params>): Promise<DduItem[]> {
    return Promise.resolve(
      args.items.filter((item) =>
        this.#colorschemes.includes(
          ensure(item.action, is.ObjectOf({ name: is.String })).name,
        )
      ),
    );
  }

  override params(): Params {
    return {};
  }
}
