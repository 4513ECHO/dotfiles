import type { Denops } from "https://deno.land/x/denops_std@v6.4.0/mod.ts";
import { ensure, is } from "jsr:@core/unknownutil@^3.18.1";
import { exists } from "jsr:@std/fs@^1.0.0/exists";
import { expandGlob } from "jsr:@std/fs@^1.0.0/expand-glob";
import { join } from "jsr:@std/path@^1.0.2/join";
import { toFileUrl } from "jsr:@std/path@^1.0.2/to-file-url";

const decoder = new TextDecoder();

export function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async meta(): Promise<unknown> {
      return {
        meta: denops.meta,
        denoVersion: Deno.version,
        nvimVersion: denops.meta.host === "nvim"
          ? await denops.call("luaeval", "vim.version()")
          : null,
      };
    },

    async jseval(expr, ctx): Promise<unknown> {
      const fn = async function () {}.constructor(
        "denops",
        "_A",
        `"use strict";return ${ensure(expr, is.String).trim()};`,
      ) as (denops: Denops, _A: unknown) => Promise<unknown>;
      return await fn(denops, ctx);
    },

    async reload(path: unknown): Promise<void> {
      const mod = await import(
        `${toFileUrl(ensure(path, is.String)).href}#${performance.now()}`
      );
      await mod.main(denops);
    },

    getUuid(): Promise<unknown> {
      return Promise.resolve(crypto.randomUUID());
    },

    async ensureSkkJisyo(arg: unknown): Promise<unknown> {
      const root = ensure(arg, is.String);
      return (await Array.fromAsync(expandGlob("SKK-JISYO.*", { root })))
        .map((entry) => entry.path)
        .concat(await downloadLJisyo(root))
        .sort((a) => a.endsWith(".L") ? 2 : a.endsWith(".emoji-ja") ? 1 : -1);
    },

    async getGlobalTsdk(): Promise<unknown> {
      const [{ stdout: denoInfo }, { stdout: vtslsInfo }] = await Promise.all(
        [[], ["npm:@vtsls/language-server"]].map((name) =>
          new Deno.Command("deno", {
            args: ["info", "--json"].concat(name),
            stdout: "piped",
          }).output()
        ),
      );

      const { npmCache } = ensure(
        JSON.parse(decoder.decode(denoInfo)),
        is.ObjectOf({ npmCache: is.String }),
      );
      const { npmPackages } = ensure(
        JSON.parse(decoder.decode(vtslsInfo)),
        is.ObjectOf({ npmPackages: is.Record }),
      );
      const [, { version }] = ensure(
        Object.entries(npmPackages)
          .find(([name]) => name.startsWith("typescript@")),
        is.TupleOf([is.String, is.ObjectOf({ version: is.String })]),
      );
      return join(npmCache, "registry.npmjs.org", "typescript", version, "lib");
    },
  };

  return Promise.resolve();
}

async function downloadLJisyo(root: string): Promise<string[]> {
  const jisyoFile = join(root, "SKK-JISYO.L");
  const url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
  if (
    Deno.build.os === "linux" &&
    await exists("/usr/share/skk/SKK-JISYO.L", { isFile: true })
  ) {
    return ["/usr/share/skk/SKK-JISYO.L"];
  }
  if (!(await exists(jisyoFile, { isFile: true }))) {
    const file = await Deno.mkdir(root, { recursive: true })
      .then(() => Deno.create(jisyoFile));
    const response = await fetch(url);
    if (!response.ok || !response.body) {
      throw new Error("Failed to download SKK-JISYO.L");
    }
    response.body
      .pipeThrough(new DecompressionStream("gzip"))
      .pipeTo(file.writable);
  }
  return [jisyoFile];
}

