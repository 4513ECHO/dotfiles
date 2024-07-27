import type { ActionData } from "jsr:@4513echo/ddu-kind-url@0.4.0";
import {
  BaseSource,
  type GatherArguments,
  type OnInitArguments,
} from "jsr:@shougo/ddu-vim@^5.0.0/source";
import type { Item } from "jsr:@shougo/ddu-vim@^5.0.0/types";
import type {
  BasePage,
  PageList,
} from "https://pax.deno.dev/scrapbox-jp/types@0.9.0/rest.ts";

type Params = {
  project: string;
  rawTextUrl: boolean;
};

export class Source extends BaseSource<Params, ActionData> {
  override kind = "url";
  #pages: Record<string, BasePage[]> = {};

  override async onInit(args: OnInitArguments<Params>): Promise<void> {
    if (!args.sourceParams.project) {
      await args.denops.call(
        "ddu#util#print_error",
        "Invalid sourceParams: project is empty",
        "ddu-source-scrapbox_pages",
      );
      return;
    }
    const response = await fetch(
      `https://scrapbox.io/api/pages/${args.sourceParams.project}`,
    );
    if (response.ok) {
      const result = await response.json() as PageList;
      this.#pages[args.sourceParams.project] = result.pages;
    }
  }

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return new ReadableStream({
      start: (controller) => {
        const items = this.#pages[args.sourceParams.project]
          .map((item): Item<ActionData> => ({
            word: item.title,
            action: {
              url: [
                "https://scrapbox.io/",
                args.sourceParams.rawTextUrl ? "api/pages/" : "",
                args.sourceParams.project,
                "/" + encodeURI(item.title.replaceAll(" ", "_")),
                args.sourceParams.rawTextUrl ? "/text" : "",
              ].join(""),
            },
          }));
        controller.enqueue(items);
        controller.close();
      },
    });
  }

  override params(): Params {
    /* NOTE: These values are my personal preferences.
       I will change these when publishing as plugin. */
    return {
      project: "4513echo",
      rawTextUrl: true,
    };
  }
}
