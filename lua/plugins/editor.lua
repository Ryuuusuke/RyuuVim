return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = {
        preset = {
          header = [[
  _____                     _   _       _           
 |  __ \                   | \ | |     (_)          
 | |__) |   _ _   _ _   _  |  \| |_   ___ _ __ ___  
 |  _  / | | | | | | | | | | . ` \ \ / / | '_ ` _ \ 
 | | \ \ |_| | |_| | |_| | | |\  |\ V /| | | | | | |
 |_|  \_\__, |\__,_|\__,_| |_| \_| \_/ |_|_| |_| |_|
         __/ |                                      
        |___/                                       
]],
          -- stylua: ignore
        },
        sections = {
          { section = "header" },
          {
            pane = 2,
            section = "terminal",
            cmd = "",
            height = 5,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      scroll = {
        animate = {
          duration = { total = 150 },
        },
      },
      indent = {
        enabled = true,
        indent = {
          enabled = true,
        },
        scope = {
          enabled = true,
          char = "│",
        },
        -- chunk = {
        --   enabled = true,
        --   char = {
        --     corner_top = "╭",
        --     corner_bottom = "╰",
        --   },
        --   hl = "MiniIconsPurple",
        -- },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    keys = {
      { "gb", "<CMD>BufferLinePick<CR>", mode = { "n" }, desc = "BufferLine Pick" },
    },
    ---@module 'bufferline'
    ---@type fun(_, opts: bufferline.UserConfig): bufferline.UserConfig
    opts = function(_, opts)
      opts.options.show_buffer_close_icons = false
      opts.options.show_close_icon = false
      opts.options.indicator = { icon = "" }
      -- opts.options.separator_style = "slope"

      -- custom theme

      -- local config = vim.fn["gruvbox_material#get_configuration"]()
      -- local palette =
      --   vim.fn["gruvbox_material#get_palette"](config.background, config.foreground, config.colors_override)
      --
      --
      -- opts.highlights = get_hl({
      --   c = {
      --     inactive_bg = palette.bg3[1],
      --     inactive_fg = palette.fg0[1],
      --     active_bg = palette.grey2[1],
      --     active_fg = palette.bg0[1],
      --     bg = palette.bg_statusline1[1],
      --   },
      --   light_palette = {
      --     blue = "#226b79",
      --     yellow = "#7a520a",
      --     red = "#af2528",
      --     green = "#64681a",
      --     aqua = "#477a5b",
      --     orange = "#b94c07",
      --     purple = "#924f79",
      --   },
      --   dark_palette = {
      --     yellow = palette.yellow[1],
      --     red = palette.red[1],
      --     blue = palette.blue[1],
      --   },
      -- })

      return opts
    end,
  },
  {
    "folke/noice.nvim",
    lazy = false,
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "Copilot is not recommended as the default auto suggestion provider",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      vim.api.nvim_set_hl(0, "NoicePopup", { link = "PMenu" })
    end,
  },
  {
    "DNLHC/glance.nvim",
    opts = function() end,
    keys = {
      { "gpd", "<CMD>Glance definitions<CR>", mode = { "n" }, desc = "Glance definitions" },
      { "gpr", "<CMD>Glance references<CR>", mode = { "n" }, desc = "Glance references" },
      { "gpy", "<CMD>Glance type_definitions<CR>", mode = { "n" }, desc = "Glance type definitions" },
      { "gpi", "<CMD>Glance implementations<CR>", mode = { "n" }, desc = "Glance implementations" },
    },
  },
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.section_separators = { right = "", left = "" }
      opts.options.component_separators = { right = "│", left = "│" }
    end,
  },
}
