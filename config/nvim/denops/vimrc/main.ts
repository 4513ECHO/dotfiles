import type { Denops } from "https://deno.land/x/denops_std@v5.0.1/mod.ts";
import { assert, is } from "https://deno.land/x/unknownutil@v3.2.0/mod.ts";
import { exists } from "https://deno.land/std@0.193.0/fs/exists.ts";
import { join } from "https://deno.land/std@0.193.0/path/mod.ts";

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

    async downloadJisyo(baseDir: unknown): Promise<unknown> {
      assert(baseDir, is.String);
      if (await exists("/usr/share/skk/SKK-JISYO.L", { isFile: true })) {
        return "/usr/share/skk/SKK-JISYO.L";
      } else if (!(await exists(baseDir, { isDirectory: true }))) {
        await denops.cmd("echomsg 'Install SKK-JISYO.L ...'");
        const url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
        const file = await Deno.mkdir(baseDir, { recursive: true })
          .then(() => Deno.create(join(baseDir, "SKK-JISYO.L")));
        const response = await fetch(url);
        response.body!
          .pipeThrough(new DecompressionStream("gzip"))
          .pipeTo(file.writable);
      }
      return join(baseDir, "SKK-JISYO.L");
    },
  };

  return Promise.resolve();
}
