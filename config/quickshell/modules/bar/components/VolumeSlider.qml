import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Widgets
import qs.config
import qs.utils
import qs.services

Item {
  id: root
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  MaterialIcon {
    id: icon
    icon: Icons.getVolumeIcon(Volume.level, Volume.muted)
    size: 26
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (popup.menuVisible)
          Volume.toggleMute()
        else
          popup.menuVisible = true
      }
    }
  }

  PopupMenu {
    id: popup
    anchorItem: icon
    onCloseRequested: menuVisible = false

    Column {
      spacing: 10
      padding: 6

      Rectangle {
        id: track
        anchors.horizontalCenter: parent.horizontalCenter
        width: 6
        height: 140
        radius: 3
        color: Theme.foregroundColor

        Rectangle {
          id: fill
          width: parent.width
          radius: parent.radius
          color: Theme.accentColor ?? Theme.textColor
          height: track.height * Volume.level
          anchors.bottom: parent.bottom
        }

        Rectangle {
          id: handle
          width: 14
          height: 14
          radius: 7
          color: Theme.textColor
          x: (track.width - width) / 2
          y: Math.max(0, Math.min(track.height - height, track.height - fill.height - height / 2))
        }

        MouseArea {
          anchors.fill: parent
          onPressed: mouse => updateFromY(mouse.y)
          onPositionChanged: mouse => { if (pressed) updateFromY(mouse.y) }

          function updateFromY(y) {
            const ratio = Math.max(0, Math.min(1, 1 - y / track.height))
            Volume.setVolume(ratio)
          }
        }
      }

      Text {
        width: track.width
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: Volume.muted ? "m" : Math.round(Volume.level * 100)
        color: Theme.textColor
        font.pixelSize: 14
      }
    }
  }
}
