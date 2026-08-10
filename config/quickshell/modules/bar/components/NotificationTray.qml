import QtQuick
import qs.config
import qs.services
import qs.utils

Item {
    id: root
    width: 26
    height: 26

    MaterialIcon {
        id: bellIcon
        anchors.centerIn: parent
        icon: "\ue7f4"
        size: 22
        color: Theme.textColor
    }

    Rectangle {
        visible: NotificationService.unreadCount > 0
        width: 14
        height: 14
        radius: 7
        color: Theme.accentColor
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: -2
        anchors.rightMargin: -2

        Text {
            anchors.centerIn: parent
            text: NotificationService.unreadCount > 9 ? "9+" : NotificationService.unreadCount
            color: Theme.backgroundColor
            font.pixelSize: 8
            font.bold: true
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            popupMenu.menuVisible = !popupMenu.menuVisible
            if (popupMenu.menuVisible)
                NotificationService.markAllRead()
        }
    }

    PopupMenu {
        id: popupMenu
        anchorItem: root
        onCloseRequested: popupMenu.menuVisible = false

        Column {
            spacing: 6
            width: 300

            Row {
                width: parent.width

                Text {
                    width: parent.width - clearLabel.width
                    text: "Notifications"
                    color: Theme.textColor
                    font.bold: true
                }

                Text {
                    id: clearLabel
                    text: "Clear"
                    color: Theme.accentColor
                    font.pixelSize: 11

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        cursorShape: Qt.PointingHandCursor
                        onClicked: NotificationService.clearHistory()
                    }
                }
            }

            Repeater {
                model: NotificationService.historyEntries

                delegate: Rectangle {
                    required property var modelData

                    width: 300
                    radius: 8
                    color: Qt.darker(Theme.backgroundColor, 1.1)
                    implicitHeight: histCol.implicitHeight + 16

                    Column {
                        id: histCol
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 4

                        Text {
                            width: parent.width
                            text: modelData.summary
                            color: Theme.textColor
                            font.bold: true
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }

                        Text {
                            visible: modelData.body && modelData.body.length > 0
                            width: parent.width
                            text: modelData.body
                            color: Theme.textColor
                            opacity: 0.8
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            Text {
                visible: NotificationService.historyEntries.length === 0
                text: "No notifications"
                color: Theme.textColor
                opacity: 0.6
                font.pixelSize: 12
            }
        }
    }
}
