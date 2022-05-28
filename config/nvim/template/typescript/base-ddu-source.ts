import type { ActionData } from "";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v1.7.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v1.7.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v1.7.0/types.ts";

// interface ActionData {}
// interface Params {}
type Params = Record<never, never>;

export class Source extends BaseSource<Params, ActionData> {
  kind = "{{_cursor_}}";

  async onInit(args: OnInitArguments<Params>): Promise<void> {}

  gather(args: GatherArguments<Params>): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start(controller) {
        controller.enqueue([]);
        controller.close();
      },
    });
  }

  params(): Params {
    return {};
  }
}
