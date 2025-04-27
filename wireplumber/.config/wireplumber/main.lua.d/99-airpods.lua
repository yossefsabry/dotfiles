rule = {
    matches = {
        {
            { "node.name", "equals", "alsa_input.pci-0000_00_1b.0.analog-stereo" }
        }
    },
    apply_properties = {
        ["audio.format"] = "S16LE",
        ["audio.rate"] = 48000,
        ["api.alsa.period-size"] = 1024
    }
}

table.insert(alsa_monitor.rules, rule)
