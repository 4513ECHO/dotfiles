import {
  BaseFilter,
  type FilterArguments,
  type OnInitArguments,
} from "jsr:@shougo/ddu-vim@^6.1.0/filter";
import type { DduItem } from "jsr:@shougo/ddu-vim@^6.1.0/types";
import { ensure, is } from "jsr:@core/unknownutil@^4.3.0";

export type Params = Record<PropertyKey, never>;

export class Filter extends BaseFilter<Params> {
  #colorschemes: string[] = [];

  async onInit(args: OnInitArguments<Params>): Promise<void> {
    this.#colorschemes = Object.keys(
      ensure(
        await args.denops.call("user#colorscheme#get"),
        is.RecordOf(is.Record),
      ),
    );
  }

  filter(args: FilterArguments<Params>): Promise<DduItem[]> {
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
