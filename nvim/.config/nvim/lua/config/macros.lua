local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- create vue component basic structure
vim.api.nvim_create_augroup("CreateVueComponentStructure", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "CreateVueComponentStructure",
	pattern = { "vue" },
	callback = function()
		vim.fn.setreg(
			"v",
			[[<template>

</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({

});
</script>

<style scoped>

</style>]]
		)
	end,
})

-- print to log an expression
vim.api.nvim_create_augroup("ConsoleLogJS", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "ConsoleLogJS",
	pattern = { "javascript", "typescript", "vue", "tsx", "jsx" },
	callback = function()
		vim.fn.setreg("l", "y" .. esc .. "o" .. esc .. "oconsole.log(`" .. esc .. "lhpli: ${" .. esc .. "hlp")
	end,
})
