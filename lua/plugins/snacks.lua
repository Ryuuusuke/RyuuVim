return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = {
      enabled = true,
      animate = {
        duration = {
          step = 10,
          total = 100,
        },
        easing = "linear",
      },
    },
  },
}
