import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets
import qs.config
import qs.utils

Item {
  id: root
  implicitWidth: powerIcon.implicitWidth
  implicitHeight: powerIcon.implicitHeight
  property bool expanded: false
  readonly property int iconSize: 26

  MaterialIcon {
    id: powerIcon

    icon: "power_settings_new"
    size: 26
    weight: 500
    grade: 200
    color: Theme.redColor

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (!root.expanded) {
          root.expanded = true
        } else {
          shutdownProc.running = true
        }
      }
    }
  }

  PopupMenu {
    id: popup
    anchorItem: powerIcon
    menuVisible: root.expanded
    onCloseRequested: root.expanded = false
    
    Row {
      spacing: 16

      MaterialIcon {
          icon: "bedtime"
          size: iconSize + 2
          weight: 300
          grade: 300
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: { sleepProc.running = true; root.expanded = false }
        }
      }

      MaterialIcon {
          icon: "restart_alt"
          size: iconSize + 2
          weight: 300
          grade: 300
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: { restartProc.running = true; root.expanded = false }
        }
      }
    }
  }

  Process { id: shutdownProc; command: ["systemctl", "poweroff"] }
  Process { id: restartProc; command: ["systemctl", "reboot"] }
  Process { id: sleepProc; command: ["systemctl", "suspend"] }
}
