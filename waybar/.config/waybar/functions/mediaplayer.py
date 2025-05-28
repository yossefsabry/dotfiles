#!/usr/bin/env python3

import json
import subprocess

def get_audio_info():
    try:
        result = subprocess.run(
            ["pactl", "list", "sinks"],
            capture_output=True,
            text=True
        )
        lines = result.stdout.split('\n')
        
        muted = "no"
        volume = "0%"
        
        for line in lines:
            if "Mute:" in line:
                muted = line.split()[1]
            elif "Volume:" in line and "base" not in line:
                volume = line.split()[4]
        
        return {
            "muted": muted,
            "volume": volume,
            "class": "audio" if muted == "no" else "muted"
        }
    except:
        return {"text": "Error", "class": "error"}

if __name__ == "__main__":
    audio = get_audio_info()
    print(json.dumps(audio))
