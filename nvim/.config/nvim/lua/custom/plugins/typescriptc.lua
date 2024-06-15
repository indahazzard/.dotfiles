return {
  "dmmulroy/tsc.nvim",
  opts = {
  auto_open_qflist = true,
  auto_close_qflist = false,
  auto_focus_qflist = false,
  auto_start_watch_mode = false,
  use_trouble_qflist = false,
  run_as_monorepo = false,
  bin_path = vim.fn.findfile("./node_modules/.bin/tsc"),
  enable_progress_notifications = true,
  flags = {
    noEmit = false,
    project = function()
      return vim.fn.findfile("./tsconfig.json")
    end,
    watch = true,
  },
  hide_progress_notifications_from_history = true,
  spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
  pretty_errors = true,
  }
}
