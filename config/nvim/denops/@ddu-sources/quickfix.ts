import type { Denops } from "jsr:@denops/std@^7.2.0";
import * as fn from "jsr:@denops/std@^7.2.0/function";
import type { ActionData } from "jsr:@shougo/ddu-kind-file@^0.9.0";
import {
  BaseSource,
  type GatherArguments,
} from "jsr:@shougo/ddu-vim@^6.1.0/source";
import type { Item } from "jsr:@shougo/ddu-vim@^6.1.0/types";
import { accumulate } from "jsr:@milly/denops-batch-accumulate@^1.0.1";

type Params = {
  useLoclist: boolean;
};
interface QflistItem {
  bufnr: number;
  lnum: number;
  col: number;
  text: string;
}

export class Source extends BaseSource<Params, ActionData> {
  override kind = "file";

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    const func: [string, ...unknown[]] = args.sourceParams.useLoclist
      ? ["getloclist", 0]
      : ["getqflist"];
    return ReadableStream.from(this.#processItems(args.denops, func));
  }

  override params(): Params {
    return {
      useLoclist: false,
    };
  }

  async *#processItems(
    denops: Denops,
    func: [string, ...unknown[]],
  ): AsyncGenerator<Item<ActionData>[]> {
    const items = await denops.call(...func) as QflistItem[];
    yield await accumulate(
      denops,
      async (denops) =>
        await Promise.all(items.map((item) => this.#processItem(denops, item))),
    );
  }

  async #processItem(
    denops: Denops,
    item: QflistItem,
  ): Promise<Item<ActionData>> {
    const bufname = await fn.bufname(denops, item.bufnr);
    return {
      word: item.text,
      display: `${bufname}|${item.lnum} col ${item.col}|${item.text}`,
      action: {
        ...item,
        lineNr: item.lnum,
      },
    };
  }
}
