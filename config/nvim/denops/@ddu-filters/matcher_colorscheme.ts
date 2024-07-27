import {
  BaseFilter,
  type FilterArguments,
  type OnInitArguments,
} from "jsr:@shougo/ddu-vim@^5.0.0/filter";
import type { DduItem } from "jsr:@shougo/ddu-vim@^5.0.0/types";
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
