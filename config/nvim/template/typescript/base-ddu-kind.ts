import type { Actions } from "https://deno.land/x/ddu_vim@v1.8.5/types.ts";
import {
  ActionFlags,
  BaseKind,
} from "https://deno.land/x/ddu_vim@v1.8.5/types.ts";

export interface ActionData {
  placeholder: unknown;
}
type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  actions: Actions<Params> = {
    action(args) {
      for (const item of args.items) {
        const _action = item?.action as ActionData;
        // {{_cursor_}}
      }
      return Promise.resolve(ActionFlags.None);
    },
  };

  params(): Params {
    return {};
  }
}
