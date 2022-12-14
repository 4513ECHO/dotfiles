import type { ActionData } from "https://pax.deno.dev/Shougo/ddu-kind-word/denops/@ddu-kinds/word.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import { TextLineStream } from "https://deno.land/std@0.167.0/streams/text_line_stream.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params, ActionData> {
  override kind = "word";
  #classifiers: Item<ActionData>[] = [];
  #stream: ReadableStream<Item<ActionData>[]> = new ReadableStream();
  #queued = 0;

  override async onInit(args: OnInitArguments<Params>): Promise<void> {
    const response = await fetch(
      "https://pypi.org/pypi?%3Aaction=list_classifiers",
    );
    if (!response.ok) {
      await args.denops.call(
        "ddu#util#print_error",
        "Failed to fetch response",
        "ddu-source-pypi_classifiers",
      );
      return;
    }
    this.#stream = response.body!
      .pipeThrough(new TextDecoderStream())
      .pipeThrough(new TextLineStream())
      .pipeThrough(
        new TransformStream({
          transform: (chunk, controller) => {
            if (this.#queued === 0) {
              controller.enqueue(this.#classifiers);
            }
            if (this.#queued >= this.#classifiers.length) {
              const item: Item<ActionData> = {
                word: chunk,
                action: { text: chunk },
              };
              this.#classifiers.push(item);
              controller.enqueue([item]);
            }
            this.#queued += 1;
          },
        }),
      );
  }

  override gather(
    _args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    this.#queued = 0;
    return this.#stream;
  }

  override params(): Params {
    return {};
  }
}
