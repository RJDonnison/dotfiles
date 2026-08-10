import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import "components"

PanelWindow {
  id: sidebar

  anchors {
    top: true
    bottom: true
    right: true
  }

  color: Theme.backgroundColor

  screen: Quickshell.screens.reduce((a, b) => a.x > b.x ? a : b)

  implicitWidth: Theme.barWidth

  Text {
    id: icon
    anchors {
      top: parent.top
      topMargin: 10
      horizontalCenter: parent.horizontalCenter
    }
    text: "\udb82\udcc7"
    font.family: "JetBrainsMono Nerd Font"
    font.pixelSize: 18
    color: Theme.textColor
  }

  RunningApps {
    anchors {
      top: icon.bottom
      topMargin: 10
      horizontalCenter: parent.horizontalCenter
    }
  }

  NotificationTray {
    anchors {
      bottom: clock.top
      bottomMargin: 10
      horizontalCenter: parent.horizontalCenter
    }
  }

  Clock {
    id: clock

     anchors {
      bottom: pill.top
      bottomMargin: 10
      horizontalCenter: parent.horizontalCenter
    }
  }

  Rectangle {
    id: pill
    anchors {
        bottom: powerMenu.top
        bottomMargin: 10
        horizontalCenter: parent.horizontalCenter
    }
    property real itemSpacing: 5
    property real padding: 4
    property real iconSlot: 26
    default property alias content: column.children
    implicitWidth: column.implicitWidth + padding * 2
    implicitHeight: column.implicitHeight + padding * 2
    radius: implicitWidth / 2
    color: Theme.foregroundColor

    Column {
        id: column
        anchors.centerIn: parent
        spacing: pill.itemSpacing

        Item {
            width: pill.iconSlot
            height: pill.iconSlot
            WifiMenu {
                anchors.centerIn: parent
            }
        }
        Item {
            width: pill.iconSlot
            height: pill.iconSlot
            BluetoothMenu {
                anchors.centerIn: parent
            }
        }
        Item {
            width: pill.iconSlot
            height: pill.iconSlot
            VolumeSlider {
                anchors.centerIn: parent
            }
        }
    }
  }

  PowerMenu {
    id: powerMenu
    anchors {
      bottom: parent.bottom
      bottomMargin: 4
      horizontalCenter: parent.horizontalCenter
    }
  }
}
