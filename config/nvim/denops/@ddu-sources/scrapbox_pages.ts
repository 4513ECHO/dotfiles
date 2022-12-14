import type { ActionData } from "https://pax.deno.dev/4513ECHO/ddu-kind-url@0.1.1/denops/@ddu-kinds/url.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v2.0.0/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";
import type {
  BasePage,
  PageList,
} from "https://pax.deno.dev/scrapbox-jp/types@0.3.6/rest.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v2.0.0/types.ts";

interface Params {
  project: string;
  rawTextUrl: boolean;
}

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
        const items = this.#pages[args.sourceParams.project].map((
          i,
        ): Item<ActionData> => ({
          word: i.title,
          action: {
            url: `https://scrapbox.io/${
              args.sourceParams.rawTextUrl ? "api/pages/" : ""
            }${args.sourceParams.project}/${
              encodeURI(i.title.replaceAll(" ", "_"))
            }${args.sourceParams.rawTextUrl ? "/text" : ""}`,
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
