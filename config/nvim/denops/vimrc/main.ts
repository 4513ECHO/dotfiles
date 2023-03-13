import type { Denops } from "https://deno.land/x/denops_std@v4.0.0/mod.ts";

export function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async meta(): Promise<unknown> {
      return {
        meta: denops.meta,
        denoVersion: Deno.version,
        nvimVersion: denops.meta.host === "nvim"
          ? await denops.call("luaeval", "vim.version()")
          : {},
      };
    },
  };

  return Promise.resolve();
}
