import type { ActionData } from "https://pax.deno.dev/4513ECHO/ddu-kind-url@0.1.1/denops/@ddu-kinds/url.ts";
import type {
  GatherArguments,
  OnInitArguments,
} from "https://deno.land/x/ddu_vim@v1.8.8/base/source.ts";
import type { Item } from "https://deno.land/x/ddu_vim@v1.8.8/types.ts";
import type {
  Page,
  PageList,
} from "https://pax.deno.dev/scrapbox-jp/types@0.3.5/rest.ts";
import { BaseSource } from "https://deno.land/x/ddu_vim@v1.8.8/types.ts";

interface Params {
  project: string;
  rawTextUrl: boolean;
}

export class Source extends BaseSource<Params, ActionData> {
  kind = "url";
  private pages: Record<string, Page[]> = [];

  async onInit(args: OnInitArguments<Params>): Promise<void> {
    if (!args.sourceParams.project) {
      await args.denops.call(
        "ddu#util#print_error",
        "Invalid sourceParams: project is empty",
      );
      return;
    }
    const response = await fetch(
      `https://scrapbox.io/api/pages/${args.sourceParams.project}`,
    );
    if (response.ok) {
      const result = await response.json() as PageList;
      this.pages[args.sourceParams.project] = result.pages;
    }
  }

  gather(args: GatherArguments<Params>): ReadableStream<Item<ActionData>[]> {
    const { pages } = this;
    return new ReadableStream({
      start(controller) {
        const items = pages[args.sourceParams.project].map((
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

  params(): Params {
    /* NOTE: These values are my personal preferences.
       I will change these when publishing as plugin. */
    return {
      project: "4513echo",
      rawTextUrl: true,
    };
  }
}
