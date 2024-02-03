return {
	"nvim-telescope/telescope-project.nvim",
	config = function()
		vim.api.nvim_set_keymap(
			"n",
			"<leader>vp",
			":lua require'telescope'.extensions.project.project{}<CR>",
			{ noremap = true, silent = true }
		)
		require("telescope").setup({
			extensions = {
				project = {
					base_dirs = {
						"~/Documents",
						{ "~/projects" },
						{ "~/dev/src3", max_depth = 4 },
						{ path = "~/dev/src4" },
						{ path = "~/dev/src5", max_depth = 2 },
					},
					hidden_files = true,
					theme = "dropdown",
					order_by = "asc",
					search_by = "title",
					sync_with_nvim_tree = true,
                    -- todo : find project dont work for tmux
					on_project_selected = function(prompt_bufnr)
						local project_path = require("telescope._extensions.project.actions").get_selected_project(prompt_bufnr)
						if project_path then
							local tmux_command = string.format("tmux new-session -c '%s'", project_path)
							vim.fn.system(tmux_command)
						end
						require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
						require("harpoon.ui").nav_file(1)
					end,
				},
			},
		})
	end,
}

