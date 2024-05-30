return {
    "mfussenegger/nvim-dap",
    -- "mfussenegger/nvim-jdtls", -- for java debug
    "mfussenegger/nvim-dap-python", -- for python
    dependencies = {
        "rcarriga/nvim-dap-ui",
    },
    config = function()
        require("dapui").setup()

        local dap, dapui = require("dap"), require("dapui")

        -- ================== python ===============
        dap.adapters.python = function(cb, config)
            if config.request == 'attach' then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or '127.0.0.1'
                cb({
                    type = 'server',
                    port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                    host = host,
                    options = {
                        source_filetype = 'python',
                    },
                })
            else
                cb({
                    type = 'executable',
                    command = '/home/yossef/debugging/.virtualenvs/debugpy/bin/python',
                    args = { '-m', 'debugpy.adapter' },
                    options = {
                        source_filetype = 'python',
                    },
                })
            end
            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = "Launch file",

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/usr/bin/python'
                        end
                    end,
                },
            }
        end
        -- ================== { { { python } } } ===============

        -- ================== javascirpt ===============
        dap.adapters.node2 = {
            type = 'executable',
            command = 'node',
            args = { os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js' },
        }
        dap.configurations.javascript = {
            {
                name = 'Launch',
                type = 'node2',
                request = 'launch',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                console = 'integratedTerminal',
            },
            {
                -- For this to work you need to make sure the node process is started with the `--inspect` flag.
                name = 'Attach to process',
                type = 'node2',
                request = 'attach',
                processId = require 'dap.utils'.pick_process,
            },
        }
        -- ================== { { { javascirpt } } } ===============
        --
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
        vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
        vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
        vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
    end,
}
