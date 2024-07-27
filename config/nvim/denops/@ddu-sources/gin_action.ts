import {
  BaseSource,
  type GatherArguments,
} from "jsr:@shougo/ddu-vim@^5.0.0/source";
import {
  ActionFlags,
  type Actions,
  type Item,
} from "jsr:@shougo/ddu-vim@^5.0.0/types";
import type { ActionData } from "jsr:@shougo/ddu-kind-word@0.3.0";
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
