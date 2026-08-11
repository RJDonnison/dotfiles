import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.config
import qs.services

PanelWindow {
    id: root

    property int popupWidth: 340
    property int sidebarWidth: Theme.barWidth
    property int topMargin: 8
    property int itemSpacing: 8
    property int defaultTimeout: 5000

  screen: Quickshell.screens.reduce((a, b) => a.x > b.x ? a : b)

    anchors { top: true; right: true }
    margins { top: root.topMargin; right: root.sidebarWidth / 2 }
    implicitWidth: root.popupWidth
    implicitHeight: popupColumn.implicitHeight
    color: "transparent"
    exclusiveZone: 0

    ColumnLayout {
        id: popupColumn
        width: root.popupWidth
        spacing: root.itemSpacing

        Repeater {
            model: NotificationService.activeNotifications

            delegate: Item {
                id: card
                required property var modelData

                readonly property var notif: modelData
                readonly property bool critical: notif.urgency === NotificationUrgency.Critical

                Layout.fillWidth: true
                implicitHeight: cardLayout.implicitHeight + 20

                Timer {
                    running: !card.critical
                    interval: card.notif.expireTimeout > 0 ? card.notif.expireTimeout * 1000 : root.defaultTimeout
                    onTriggered: card.notif.expire()
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    color: Theme.backgroundColor
                    border.width: card.critical ? 2 : 0
                    border.color: Theme.accentColor
                }

                ColumnLayout {
                    id: cardLayout
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 6

                    RowLayout {
                        spacing: 8

                        IconImage {
                            implicitSize: 24
                            source: Quickshell.iconPath(card.notif.appIcon, "dialog-information")
                        }

                        Text {
                            Layout.fillWidth: true
                            text: card.notif.summary
                            color: Theme.textColor
                            font.bold: true
                            font.pixelSize: 13
                            elide: Text.ElideRight
                        }

                        Text {
                            text: "\u2715"
                            color: Theme.textColor
                            font.pixelSize: 12

                            MouseArea {
                                anchors.fill: parent
                                anchors.margins: -6
                                cursorShape: Qt.PointingHandCursor
                                onClicked: card.notif.dismiss()
                            }
                        }
                    }

                    Text {
                        visible: card.notif.body.length > 0
                        Layout.fillWidth: true
                        text: card.notif.body
                        color: Theme.textColor
                        opacity: 0.85
                        font.pixelSize: 12
                        wrapMode: Text.WordWrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                    }

                    RowLayout {
                        visible: card.notif.actions.length > 0
                        spacing: 6

                        Repeater {
                            model: card.notif.actions

                            delegate: Rectangle {
                                required property var modelData

                                radius: 6
                                color: Theme.accentColor
                                implicitWidth: actionLabel.implicitWidth + 16
                                implicitHeight: actionLabel.implicitHeight + 8

                                Text {
                                    id: actionLabel
                                    anchors.centerIn: parent
                                    text: modelData.text
                                    color: Theme.backgroundColor
                                    font.pixelSize: 11
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.invoke()
                                }
                            }
                        }
                    }

                    RowLayout {
                        visible: card.notif.hasInlineReply
                        spacing: 6

                        TextField {
                            id: replyField
                            Layout.fillWidth: true
                            placeholderText: card.notif.inlineReplyPlaceholder
                            onAccepted: {
                                card.notif.sendInlineReply(text)
                                text = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
