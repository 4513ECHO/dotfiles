import {
  BaseFilter,
  type FilterArguments,
  type OnInitArguments,
} from "https://deno.land/x/ddu_vim@v3.4.3/base/filter.ts";
import type { DduItem } from "https://deno.land/x/ddu_vim@v3.4.3/types.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.4.0/mod.ts";

export type Params = Record<never, never>;

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
