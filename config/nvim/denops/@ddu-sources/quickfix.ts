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
    return new ReadableStream({
      async start(controller) {
        const func: [string, ...unknown[]] = args.sourceParams.useLoclist
          ? ["getloclist", 0]
          : ["getqflist"];
        const items = await args.denops.call(...func) as QflistItem[];
        controller.enqueue(
          await accumulate(
            args.denops,
            async (denops) =>
              await Promise.all(items.map(async (i) => {
                const bufname = await fn.bufname(denops, i.bufnr);
                return {
                  word: i.text,
                  display: `${bufname}|${i.lnum} col ${i.col}|${i.text}`,
                  action: {
                    ...i,
                    lineNr: i.lnum,
                  },
                } satisfies Item<ActionData>;
              })),
          ),
        );
        controller.close();
      },
    });
  }

  override params(): Params {
    return {
      useLoclist: false,
    };
  }
}
