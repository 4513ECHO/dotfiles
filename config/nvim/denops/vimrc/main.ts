import type { Denops } from "https://deno.land/x/denops_std@v5.0.1/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.4.0/mod.ts";
import { exists } from "https://deno.land/std@0.198.0/fs/exists.ts";
import { join, toFileUrl } from "https://deno.land/std@0.198.0/path/mod.ts";
import { TextLineStream } from "https://deno.land/std@0.198.0/streams/text_line_stream.ts";

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

    jseval(expr, ctx): Promise<unknown> {
      const fn = new Function(
        "_A",
        `"use strict";return ${ensure(expr, is.String).trim()};`,
      ) as (ctx: unknown) => unknown;
      return Promise.resolve(fn(ctx));
    },

    async reload(path: unknown): Promise<void> {
      const mod = await import(
        `${toFileUrl(ensure(path, is.String)).href}#${performance.now()}`
      );
      await mod.main(denops);
    },

    async downloadJisyo(arg: unknown): Promise<unknown> {
      const baseDir = ensure(arg, is.String);
      if (await exists("/usr/share/skk/SKK-JISYO.L", { isFile: true })) {
        return "/usr/share/skk/SKK-JISYO.L";
      }
      const jisyoFile = join(baseDir, "SKK-JISYO.L");
      const url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
      if (!(await exists(baseDir, { isDirectory: true }))) {
        await denops.cmd("echomsg 'Install SKK-JISYO.L ...'");
        const file = await Deno.mkdir(baseDir, { recursive: true })
          .then(() => Deno.create(jisyoFile));
        const response = await fetch(url);
        response.body!
          .pipeThrough(new DecompressionStream("gzip"))
          .pipeTo(file.writable);
      }
      return jisyoFile;
    },

    async cacheLanguageServers(arg: unknown): Promise<void> {
      const cacheDir = join(ensure(arg, is.String), "ls");
      if ((await exists(cacheDir, { isDirectory: true }))) {
        return;
      }
      await Deno.mkdir(cacheDir, { recursive: true });
      const { stderr } = new Deno.Command("deno", {
        args: [
          "cache",
          "--reload",
          "--node-modules-dir",
          "npm:@vtsls/language-server@0.1.20", //
          "npm:yaml-language-server@1.13.0", //
          "npm:prettier@2.8.8", //
        ],
        cwd: cacheDir,
        stderr: "piped",
        env: { NO_COLOR: "1" },
      }).spawn();
      stderr
        .pipeThrough(new TextDecoderStream())
        .pipeThrough(new TextLineStream())
        .pipeTo(new EchomsgStream(denops));
    },
  };

  return Promise.resolve();
}

class EchomsgStream extends WritableStream<string> {
  constructor(denops: Denops) {
    super({
      write: (chunk) => {
        this.#echo(denops, chunk);
      },
      close: () => {
        this.#echo(denops, "Caching Done");
        ["vtsls", "yamlls"].map((server) =>
          denops.call("luaeval", "require('lspconfig')[_A].launch()", server)
        );
        this.#echo(denops, "Servers Restarted");
      },
    });
  }

  #echo(denops: Denops, chunk: string): void {
    denops.call("nvim_echo", [["[Caching LS] ", "Comment"], [chunk]], true, []);
  }
}
