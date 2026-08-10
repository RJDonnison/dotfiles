pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [ root.sink ]
    }

    readonly property bool available:
        sink !== null && sink.audio !== null
    readonly property real level:
        available ? sink.audio.volume : 0
    readonly property bool muted:
        available ? sink.audio.muted : false

    function setVolume(value: real) {
        if (!available)
            return
        sink.audio.volume = Math.max(0, Math.min(1, value))
    }
    function increase(amount = 0.05) {
        setVolume(level + amount)
    }
    function decrease(amount = 0.05) {
        setVolume(level - amount)
    }
    function toggleMute() {
        if (available)
            sink.audio.muted = !sink.audio.muted
    }
}
