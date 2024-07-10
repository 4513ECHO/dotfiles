import type { GatherArguments } from "https://deno.land/x/ddu_vim@v3.10.3/base/source.ts";
import {
  ActionFlags,
  type Actions,
  type Item,
} from "https://deno.land/x/ddu_vim@v3.10.3/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v3.10.3/types.ts";
import type { ActionData } from "https://deno.land/x/ddu_kind_word@v0.2.1/word.ts";
import { ensure } from "jsr:@denops/std@^7.0.1/buffer";
import {
  exprQuote as q,
  useExprString,
} from "jsr:@denops/std@^7.0.1/helper/expr_string";

type Params = Record<PropertyKey, never>;
const collector =
  "maplist()->filter({ -> v:val.lhs->stridx('<Plug>(gin-action') ==# 0 })->map({ -> v:val.lhs })";

export class Source extends BaseSource<Params, ActionData> {
  override kind = "word";

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start: async (controller) => {
        const items = await ensure(
          args.denops,
          args.context.bufNr,
          () => args.denops.eval(collector) as Promise<string[]>,
        );
        controller.enqueue(
          items.map((text) => ({
            word: text.match(/<Plug>\(gin-action-(.*)\)/)![1],
            action: { text },
          })),
        );
        controller.close();
      },
    });
  }

  override actions: Actions<Params> = {
    execute: async (args) => {
      await useExprString(args.denops, async (denops) => {
        for (const item of args.items) {
          const { text } = item.action as ActionData;
          await denops.call(
            "feedkeys",
            q`${text.replaceAll("<", "\\<")}`,
            "mi",
          );
        }
      });
      return ActionFlags.None;
    },
  };

  override params(): Params {
    return {};
  }
}
