import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.utils
import qs.services

Item {
    id: root
    width: parent.width
    height: column.implicitHeight

    Column {
        id: column
        anchors.fill: parent

        MaterialIcon {
            width: parent.width
            icon: "calendar_month"
            size: 22
        }

        Text {
            id: clock
            width: parent.width
            color: Theme.textColor
            font.family: "JetBrains Mono"
            font.pixelSize: 16
            font.weight: Font.Medium
            horizontalAlignment: Text.AlignHCenter
            text: String(Time.hours).padStart(2, "0") + "\n" + String(Time.minutes).padStart(2, "0")
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: calendarPopup.menuVisible = !calendarPopup.menuVisible
    }

    PopupMenu {
        id: calendarPopup
        anchorItem: root
        onCloseRequested: calendarPopup.menuVisible = false

        Calendar {}
    }
}
