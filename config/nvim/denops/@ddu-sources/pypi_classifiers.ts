import type { ActionData } from "https://pax.deno.dev/Shougo/ddu-kind-word/denops/@ddu-kinds/word.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v1.8.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v1.8.0/types.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v1.8.0/types.ts";

type Params = Record<never, never>;

// based on https://developer.mozilla.org/ja/docs/Web/API/Fetch_API/Using_Fetch
async function* IterLines(
  body: ReadableStream<Uint8Array>,
): AsyncIterable<string> {
  const decoder = new TextDecoder();
  const reader = body.getReader();
  let { value, done: readerDone } = await reader.read();
  let chunk = value ? decoder.decode(value) : "";

  const re = /\n|\r|\r\n/gm;
  let startIndex = 0;

  while (true) {
    const result = re.exec(chunk);
    if (!result) {
      if (readerDone) {
        break;
      }
      const remainder = chunk.substr(startIndex);
      ({ value, done: readerDone } = await reader.read());
      chunk = remainder + (value ? decoder.decode(value) : "");
      startIndex = re.lastIndex = 0;
      continue;
    }
    yield chunk.substring(startIndex, result.index);
    startIndex = re.lastIndex;
  }
  if (startIndex < chunk.length) {
    // last line didn't end in a newline char
    yield chunk.substr(startIndex);
  }
}

export class Source extends BaseSource<Params, ActionData> {
  kind = "word";
  private classifiers: string[] = [];

  async onInit(_args: OnInitArguments<Params>): Promise<void> {
    const response = await fetch(
      "https://pypi.org/pypi?%3Aaction=list_classifiers",
    );
    if (response.ok) {
      for await (const line of IterLines(response.body)) {
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
