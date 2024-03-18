import type { Denops } from "https://deno.land/x/denops_std@v6.4.0/mod.ts";
import { ensure, is } from "https://deno.land/x/unknownutil@v3.17.0/mod.ts";
import { exists } from "https://deno.land/std@0.220.1/fs/exists.ts";
import { join, toFileUrl } from "https://deno.land/std@0.220.1/path/mod.ts";
import { TextLineStream } from "https://deno.land/std@0.220.1/streams/text_line_stream.ts";

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

    async downloadJisyo(arg: unknown): Promise<unknown> {
      const baseDir = ensure(arg, is.String);
      const jisyoFile = join(baseDir, "SKK-JISYO.L");
      const url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
      if (Deno.build.os === "darwin") {
        return jisyoFile;
      } else if (
        Deno.build.os === "linux" &&
        await exists("/usr/share/skk/SKK-JISYO.L", { isFile: true })
      ) {
        return "/usr/share/skk/SKK-JISYO.L";
      }
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

    async cacheVtsls(arg: unknown): Promise<unknown> {
      const cacheDir = join(ensure(arg, is.String), "ls");
      const vtsls = join(
        cacheDir,
        "node_modules",
        "@vtsls",
        "language-server",
        "bin",
        "vtsls.js",
      );
      if (await exists(cacheDir, { isDirectory: true })) {
        return vtsls;
      }
      await Deno.mkdir(cacheDir, { recursive: true });
      const { stderr } = new Deno.Command("deno", {
        args: [
          "cache",
          "--reload",
          "--node-modules-dir",
          "npm:@vtsls/language-server@0.1.23",
        ],
        cwd: cacheDir,
        stderr: "piped",
        env: { NO_COLOR: "1" },
      }).spawn();
      stderr
        .pipeThrough(new TextDecoderStream())
        .pipeThrough(new TextLineStream())
        .pipeTo(new FidgetStream(denops));
      return vtsls;
    },
  };

  return Promise.resolve();
}

class FidgetStream extends WritableStream<string> {
  constructor(denops: Denops) {
    super({
      write: (chunk) => {
        this.#echo(denops, chunk, false);
      },
      close: () => {
        denops.call("luaeval", `require("lspconfig").vtsls.launch()`);
        this.#echo(denops, "Server Restarted", true);
      },
    });
  }

  #echo(denops: Denops, chunk: string, done: boolean): void {
    denops.call(
      "luaeval",
      `require("vimrc.plugins.fidget").${done ? "done" : "report"}(_A)`,
      chunk,
    );
  }
}
