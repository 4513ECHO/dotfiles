import type { ActionData } from "./base-ddu-kind.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

// interface ActionData {}
// interface Params {}
type Params = Record<never, never>;

export class Source extends BaseSource<Params, ActionData> {
  override kind = "{{_cursor_}}";

  override async onInit(_args: OnInitArguments<Params>): Promise<void> {}

  override gather(
    _args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start: (controller) => {
        controller.enqueue([]);
        controller.close();
      },
    });
  }

  override params(): Params {
    return {};
  }
}
