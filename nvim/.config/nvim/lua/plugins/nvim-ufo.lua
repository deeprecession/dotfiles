return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "close all folds" })
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "open folds except kinds" })
    end,
  },
}
