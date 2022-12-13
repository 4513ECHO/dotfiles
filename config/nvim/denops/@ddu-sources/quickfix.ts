import * as fn from "https://deno.land/x/denops_std@v3.11.3/function/mod.ts";
import type { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.2/file.ts";
import type { GatherArguments } from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

interface Params {
  useLoclist: boolean;
}
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
        const func = args.sourceParams.useLoclist
          ? ["getloclist", 0]
          : ["getqflist"];
        const items: QflistItem[] = await args.denops.call(...func);
        controller.enqueue(
          await Promise.all(
            items.map(async (i): Promise<Item<ActionData>> => ({
              word: i.text,
              display: `${await fn.bufname(
                args.denops,
                i.bufnr,
              )}|${i.lnum} col ${i.col}|${i.text}`,
              action: {
                bufNr: i.bufnr,
                col: i.col,
                lineNr: i.lnum,
                text: i.text,
              },
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
