import type { ActionData } from "https://pax.deno.dev/Shougo/ddu-kind-word/denops/@ddu-kinds/word.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.6.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v2.6.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v2.6.0/types.ts";
import { TextLineStream } from "https://deno.land/std@0.181.0/streams/text_line_stream.ts";
import { ChunkedStream } from "https://deno.land/x/chunked_stream@0.1.2/mod.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params, ActionData> {
  override kind = "word";
  #stream: ReadableStream<Item<ActionData>[]> = new ReadableStream();

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
        new TransformStream<string, Item<ActionData>>({
          transform: (chunk, controller) => {
            controller.enqueue({
              word: chunk,
              action: { text: chunk },
            });
          },
        }),
      )
      .pipeThrough(new ChunkedStream({ chunkSize: 100 }));
  }

  override gather(
    _args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return this.#stream;
  }

  override params(): Params {
    return {};
  }
}
