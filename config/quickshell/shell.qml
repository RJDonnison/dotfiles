import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.modules
import qs.modules.bar

ShellRoot {
    property var targetScreen: Quickshell.screens.reduce((a, b) => a.x > b.x ? a : b)

    Loader {
        id: barLoader
        active: true
        sourceComponent: Component {
            Bar { screen: targetScreen }
        }
    }

    onTargetScreenChanged: {
        barLoader.active = false
        barLoader.active = true
    }

    Notifications {
        sidebarWidth: Theme.barWidth
    }
}
