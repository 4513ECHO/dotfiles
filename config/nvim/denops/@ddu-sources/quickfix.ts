import * as fn from "https://deno.land/x/denops_std@v3.8.1/function/mod.ts";
import type { ActionData } from "https://deno.land/x/ddu_kind_file@v0.3.0/file.ts";
import type { GatherArguments } from "https://deno.land/x/ddu_vim@v1.9.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v1.9.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v1.9.0/types.ts";

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
  kind = "file";

  gather(args: GatherArguments<Params>): ReadableStream<Item<ActionData>[]> {
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

  params(): Params {
    return {
      useLoclist: false,
    };
  }
}
