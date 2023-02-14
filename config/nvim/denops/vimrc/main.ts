import type { Denops } from "https://deno.land/x/denops_std@v4.0.0/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    meta(): Promise<unknown> {
      return Promise.resolve({
        meta: denops.meta,
        version: Deno.version,
      });
    },
  };
  await Promise.resolve();
}
