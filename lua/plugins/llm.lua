local prefix = "C"

return {
  {
    "robitx/gp.nvim",
    cmd = {
      prefix .. "ChatNew",       -- open a chat in the current window
      prefix .. "ChatPaste",     -- paste the selection into the last chat
      prefix .. "ChatToggle",    -- toggle chat window (or create)
      prefix .. "ChatFinder",    -- search through past chats
      prefix .. "ChatRespond",   -- request a new response in the current chat
      prefix .. "ChatDelete",    -- delete the current chat
      prefix .. "Rewrite",       -- replace given context using a prompt
      prefix .. "Append",        -- append given context using a prompt
      prefix .. "Prepend",       -- prepend given context using a prompt
      prefix .. "Enew",          -- like GpRewrite, but in a new buffer in the current window
      prefix .. "New",           -- like GpRewrite, but in a new horizontally split window
      prefix .. "Vnew",          -- like GpRewrite, but in a new vertically split window
      prefix .. "Tabnew",        -- like GpRewrite, but in a new tab
      prefix .. "Popup",         -- like GpRewrite, but in a new popup window
      prefix .. "Implement",     -- write code using a comment
      prefix .. "Context",       -- provides context per repository in `.gp.md`
      prefix .. "NextAgent",     -- use next configured agent
      prefix .. "Agent",         -- display or set used agent
      prefix .. "Stop",          -- stop all running responses and jobs
      prefix .. "InspectPlugin", -- inspect prompt plugin in scratch buffer
    },
    lazy = true,
    config = function()
      require("gp").setup({
        prefix = prefix,
        providers = {
          pplx = {
            endpoint = "https://api.perplexity.ai/chat/completions",
            secret = vim.env["PPLX_API_KEY"],
          },
        },
        log_sensitive = false,
        default_command_agent = "PerplexityCode",
        default_chat_agent = "PerplexityChat",
        agents = {
          {
            provider = "pplx",
            name = "PerplexityChat",
            chat = true,
            command = false,
            ---@type "sonar" | "sonar-pro" | "sonar-reasoning" | "sonar-reasoning-pro"
            model = "sonar",
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "pplx",
            name = "PerplexityCode",
            chat = false,
            command = true,
            ---@type "sonar" | "sonar-pro" | "sonar-reasoning" | "sonar-reasoning-pro"
            model = "sonar",
            system_prompt = require("gp.defaults").code_system_prompt,
          },
        },
      })
    end,
  },
}
