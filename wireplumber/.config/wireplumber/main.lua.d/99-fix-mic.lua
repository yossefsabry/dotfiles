


rule = {
    matches = {
        {
            { "node.name", "equals", "alsa_input.pci-0000_00_1b.0.analog-stereo" }
        }
    },
    apply_properties = {
        ["target.object"] = "alsa_input.pci-0000_00_1b.0.analog-stereo",
        ["target.port.name"] = "analog-input-headset-mic",
        ["priority.driver"] = 3000,
        ["priority.session"] = 3000,
        ["session.suspend-timeout-seconds"] = 0
    }
}

table.insert(alsa_monitor.rules, rule)
