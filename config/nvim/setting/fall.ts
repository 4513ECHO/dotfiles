import type { Entrypoint } from "jsr:@vim-fall/custom@^0.1.0";
import {
  action,
  coordinator,
  matcher,
  previewer,
  renderer,
  sorter,
  source,
  theme,
} from "jsr:@vim-fall/std@^0.10.0/builtin";
import * as extra from "jsr:@vim-fall/extra@^0.2.0";
import * as alacarte from "jsr:@4513echo/fall-alacarte@^0.2.0";

const defaultQuickfixActions = {
  ...action.defaultQuickfixActions,
  "quickfix:qfreplace": action.quickfix({ after: "Qfreplace" }),
};

export const main: Entrypoint = ({ refineSetting, definePickerFromSource }) => {
  refineSetting({
    coordinator: coordinator.modern({
      heightRatio: 2 / 3,
      widthRatio: 2 / 3,
      previewRatio: 1 / 2,
    }),
    theme: theme.MODERN_THEME,
  });

  definePickerFromSource("mru", extra.source.mr, {
    matchers: [matcher.fzf, matcher.regexp],
    sorters: [sorter.noop],
    renderers: [alacarte.renderer.tildePath, renderer.noop],
    previewers: [previewer.file],
    actions: {
      ...action.defaultOpenActions,
      ...defaultQuickfixActions,
      ...action.defaultYankActions,
      ...action.defaultSubmatchActions,
      ...extra.action.defaultMrDeleteActions,
    },
    defaultAction: "open",
  });

  definePickerFromSource("mrw", extra.source.mr({ type: "mrw" }), {
    matchers: [matcher.fzf],
    sorters: [sorter.noop],
    renderers: [alacarte.renderer.tildePath, renderer.noop],
    previewers: [previewer.file],
    actions: {
      ...action.defaultOpenActions,
      ...defaultQuickfixActions,
      ...action.defaultSubmatchActions,
      ...extra.action.defaultMrDeleteActions,
    },
    defaultAction: "open",
  });

  definePickerFromSource("help", source.helptag, {
    matchers: [matcher.fzf],
    renderers: [renderer.helptag],
    previewers: [previewer.helptag],
    actions: {
      ...action.defaultHelpActions,
      ...action.defaultSubmatchActions,
    },
    defaultAction: "help",
  });

  definePickerFromSource("colorscheme", alacarte.source.colorscheme, {
    matchers: [matcher.fzf],
    actions: {
      ...alacarte.action.defaultColorschemeActions,
    },
    defaultAction: "colorscheme",
  });
};
