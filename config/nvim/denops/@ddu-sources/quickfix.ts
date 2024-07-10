import * as fn from "jsr:@denops/std@^7.0.1/function";
import type { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import {
  BaseSource,
  type GatherArguments,
} from "https://deno.land/x/ddu_vim@v3.10.3/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v3.10.3/types.ts";
import { defer } from "https://deno.land/x/denops_defer@v1.0.0/batch/defer.ts";

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
          await defer(args.denops, (denops) =>
            items.map((i) => ({
              word: i.text,
              display: fn.bufname(denops, i.bufnr)
                .then((name) => `${name}|${i.lnum} col ${i.col}|${i.text}`),
              action: {
                bufNr: i.bufnr,
                col: i.col,
                lineNr: i.lnum,
                text: i.text,
              },
            }))),
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
