import {
  BaseSource,
  type GatherArguments,
} from "jsr:@shougo/ddu-vim@^6.1.0/source";
import {
  ActionFlags,
  type Actions,
  type Item,
} from "jsr:@shougo/ddu-vim@^6.1.0/types";
import type { Denops } from "jsr:@denops/std@^7.2.0";
import { compare } from "jsr:@std/semver@^1.0.2/compare";
import { format as formatSemVer } from "jsr:@std/semver@^1.0.2/format";
import { increment } from "jsr:@std/semver@^1.0.2/increment";
import { tryParse } from "jsr:@std/semver@^1.0.2/try-parse";
import type { ReleaseType, SemVer } from "jsr:@std/semver@^1.0.2/types";
import { TextLineStream } from "jsr:@std/streams@^1.0.3/text-line-stream";

type ActionData = {
  type: "release_type";
  releaseType: ReleaseType;
} | {
  type: "current_version";
};
type Params = {
  baseVersion: string;
};
type Version = { startsWithV: boolean; semver: SemVer };

const decoder = new TextDecoder();
const isVersion = (x: { semver?: SemVer }): x is Version => !!x.semver;

async function getLatestVersion(
  cwd: string,
  baseVersion: string,
): Promise<Version | undefined> {
  if (baseVersion) {
    const semver = tryParse(baseVersion);
    if (semver) {
      return { semver, startsWithV: baseVersion.startsWith("v") };
    }
  }
  const { stdout, success } = await new Deno.Command("git", {
    args: ["tag", "--sort=-version:refname"],
    cwd,
  }).output();
  if (!success) {
    return;
  }
  return decoder.decode(stdout).split("\n")
    .map((v) => ({ semver: tryParse(v), startsWithV: v.startsWith("v") }))
    .filter(isVersion)
    .sort(({ semver: a }, { semver: b }) => compare(b, a))
    .at(0);
}

function format(version: Version): string {
  return (version.startsWithV ? "v" : "") + formatSemVer(version.semver);
}

function pipeToEcho(denops: Denops, stream: ReadableStream<Uint8Array>): void {
  stream
    .pipeThrough(new TextDecoderStream())
    .pipeThrough(new TextLineStream())
    .pipeTo(
      new WritableStream({
        async write(chunk) {
          await denops.cmd("echo '[ddu-source-git_bump]' chunk", { chunk });
        },
      }),
    );
}

export class Source extends BaseSource<Params, ActionData> {
  override kind = "word";

  override gather(
    args: GatherArguments<Params>,
  ): ReadableStream<Item<ActionData>[]> {
    return ReadableStream.from(
      this.#processItems(args),
    );
  }

  override actions: Actions<Params> = {
    async bump(args) {
      const action = args.items.at(0)?.action as ActionData | undefined;
      if (action?.type !== "release_type") {
        return ActionFlags.Persist;
      }
      const baseVersion = await getLatestVersion(
        args.context.cwd,
        args.sourceParams.baseVersion,
      );
      if (!baseVersion) {
        return ActionFlags.Persist;
      }
      const newTag = format({
        startsWithV: baseVersion.startsWithV,
        semver: increment(baseVersion.semver, action.releaseType),
      });
      const { stdout, stderr } = new Deno.Command("git", {
        args: ["tag", newTag],
        cwd: args.context.cwd,
        stderr: "piped",
        stdout: "piped",
      }).spawn();
      [stdout, stderr].map((stream) => pipeToEcho(args.denops, stream));
      return ActionFlags.None;
    },
  };

  override params(): Params {
    return {
      baseVersion: "",
    };
  }

  async *#processItems(
    args: GatherArguments<Params>,
  ): AsyncGenerator<Item<ActionData>[]> {
    const version = await getLatestVersion(
      args.context.cwd,
      args.sourceParams.baseVersion,
    );
    if (!version) {
      yield [{
        word: "No version found",
        highlights: [{
          name: "ddu-source-git_bump",
          hl_group: "ErrorMsg",
          col: 1,
          width: 16,
        }],
      }];
      return;
    }
    yield [{
      word: `Current version: ${format(version)}`,
      highlights: [{
        name: "ddu-source-git_bump",
        hl_group: "Question",
        col: 1,
        width: 99,
      }],
      action: { type: "current_version" },
    }];
    const releaseTypes: ReleaseType[] = ["pre", "major", "minor", "patch"];
    yield releaseTypes.map((releaseType) => ({
      word: releaseType,
      action: { type: "release_type", releaseType },
    }));
  }
}
