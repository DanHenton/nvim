return {
  'github/copilot.vim',
  build = ':Copilot setup', -- <--- MAKE SURE THIS LINE IS PRESENT AND UNCOMMENTED
  event = 'VeryLazy',       -- Or 'InsertEnter', but VeryLazy is usually better
  opts = {}
}
