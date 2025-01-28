return {
  {
    "robitx/gp.nvim",
    cmd = {
      "GpChatNew",       -- open a chat in the current window
      "GpChatPaste",     -- paste the selection into the last chat
      "GpChatToggle",    -- toggle chat window (or create)
      "GpChatFinder",    -- search through past chats
      "GpChatRespond",   -- request a new response in the current chat
      "GpChatDelete",    -- delete the current chat
      "GpRewrite",       -- replace given context using a prompt
      "GpAppend",        -- append given context using a prompt
      "GpPrepend",       -- prepend given context using a prompt
      "GpEnew",          -- like GpRewrite, but in a new buffer in the current window
      "GpNew",           -- like GpRewrite, but in a new horizontally split window
      "GpVnew",          -- like GpRewrite, but in a new vertically split window
      "GpTabnew",        -- like GpRewrite, but in a new tab
      "GpPopup",         -- like GpRewrite, but in a new popup window
      "GpImplement",     -- write code using a comment
      "GpContext",       -- provides context per repository in `.gp.md`
      "GpNextAgent",     -- use next configured agent
      "GpAgent",         -- display or set used agent
      "GpStop",          -- stop all running responses and jobs
      "GpInspectPlugin", -- inspect prompt plugin in scratch buffer
    },
    lazy = true,
    config = function()
      require("gp").setup({
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
            ---@type "sonar" | "sonar-pro"
            model = "sonar",
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
          {
            provider = "pplx",
            name = "PerplexityCode",
            chat = false,
            command = true,
            ---@type "sonar" | "sonar-pro"
            model = "sonar",
            system_prompt = require("gp.defaults").code_system_prompt,
          },
        },
      })
    end,
  },
}
