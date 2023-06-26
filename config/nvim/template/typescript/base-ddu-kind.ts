import type { Actions } from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";
import {
  ActionFlags,
  BaseKind,
} from "https://deno.land/x/ddu_vim@v3.2.7/types.ts";

export type ActionData = {
  placeholder: unknown;
};
type Params = Record<never, never>;

export class Kind extends BaseKind<Params> {
  override actions: Actions<Params> = {
    action: (args) => {
      for (const item of args.items) {
        const action = item?.action as ActionData;
        action; // {{_cursor_}}
      }
      return Promise.resolve(ActionFlags.None);
    },
  };

  override params(): Params {
    return {};
  }
}
