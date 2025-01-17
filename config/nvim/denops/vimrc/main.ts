import type { Denops, Entrypoint } from "jsr:@denops/std@^7.2.0";
import { is } from "jsr:@core/unknownutil@^4.3.0/is";
import { ensure } from "jsr:@core/unknownutil@^4.3.0/ensure";
import { exists } from "jsr:@std/fs@^1.0.2/exists";
import { expandGlob } from "jsr:@std/fs@^1.0.2/expand-glob";
import { join } from "jsr:@std/path@^1.0.3/join";

const decoder = new TextDecoder();

export const main: Entrypoint = (denops) => {
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

    // TODO: split to a new plugin "quickrun-hook-denops-interrupt"?
    registerSweeper(): void {
      this.sweep = async () => {
        await denops.cmd("echomsg 'Sweeping quickrun sessions'");
        await denops.call("quickrun#session#sweep");
      };
      denops.interrupted?.addEventListener("abort", this.sweep);
    },

    unregisterSweeper(): void {
      denops.interrupted?.removeEventListener("abort", this.sweep);
    },
  };

  return {
    async [Symbol.asyncDispose](): Promise<void> {
      await denops.cmd("echomsg 'Goodbye, Denops'");
    },
  };
};

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

