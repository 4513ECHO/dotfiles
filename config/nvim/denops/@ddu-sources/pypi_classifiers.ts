import type { ActionData } from "https://pax.deno.dev/Shougo/ddu-kind-word/denops/@ddu-kinds/word.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v1.8.8/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v1.8.8/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v1.8.8/types.ts";
import { readerFromStreamReader } from "https://deno.land/std@0.150.0/streams/conversion.ts";
import { readLines } from "https://deno.land/std@0.150.0/io/mod.ts";

type Params = Record<never, never>;

export class Source extends BaseSource<Params, ActionData> {
  kind = "word";
  private classifiers: string[] = [];

  async onInit(_args: OnInitArguments<Params>): Promise<void> {
    const response = await fetch(
      "https://pypi.org/pypi?%3Aaction=list_classifiers",
    );
    if (response.ok) {
      for await (
        const line of readLines(readerFromStreamReader(response.body))
      ) {
        this.classifiers.push(line);
      }
    }
  }

  gather(_args: GatherArguments<Params>): ReadableStream<Item<ActionData>[]> {
    const { classifiers } = this;
    return new ReadableStream({
      start(controller) {
        controller.enqueue(
          classifiers.map((i): Item<ActionData> => ({
            word: i,
            action: { text: i },
          })),
        );
        controller.close();
      },
    });
  }

  params(): Params {
    return {};
  }
}
