import {
  BaseSource,
  type GatherArguments,
} from "jsr:@shougo/ddu-vim@^6.1.0/source";
import {
  ActionFlags,
  type Actions,
  type Item,
} from "jsr:@shougo/ddu-vim@^6.1.0/types";
import type { ActionData } from "jsr:@shougo/ddu-kind-word@^0.4.1";
import { ensure } from "jsr:@denops/std@^7.2.0/buffer";
import { rawString, useEval } from "jsr:@denops/std@^7.2.0/eval";

type Params = Record<PropertyKey, never>;
const collector =
  "maplist()->filter({ -> v:val.lhs->stridx('<Plug>(gin-action') ==# 0 })->map({ -> v:val.lhs })";

export class Source extends BaseSource<Params, ActionData> {
  override kind = "word";

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return ReadableStream.from(this.#processItems(args));
  }

  override actions: Actions<Params> = {
    async execute(args) {
      await useEval(args.denops, async (denops) => {
        for (const item of args.items) {
          const { text } = item.action as ActionData;
          await denops.call(
            "feedkeys",
            rawString`${text.replaceAll("<", "\\<")}`,
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

  async *#processItems(
    args: GatherArguments<Params>,
  ): AsyncGenerator<Item<ActionData>[]> {
    const items = await ensure(
      args.denops,
      args.context.bufNr,
      () => args.denops.eval(collector) as Promise<string[]>,
    );
    yield items
      .map((text) => ({
        word: text.match(/<Plug>\(gin-action-(.*)\)/)![1],
        action: { text },
      }));
  }
}
