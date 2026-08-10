import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
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

        icon: Icons.getNetworkIcon(
            Network.signalStrength,
            Network.secure
        )

        size: 20

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: popup.menuVisible = !popup.menuVisible
        }
    }

    PopupMenu {
        id: popup

        anchorItem: icon

        onCloseRequested: {
            menuVisible = false
        }

        Column {
            spacing: 10
            padding: 6

            Text {
                text: "Wi-Fi"
                color: Theme.textColor
                font.pixelSize: 14
            }

            Column {
                width: 220
                spacing: 4

                Repeater {
                    model: Network.availableNetworks

                    Rectangle {
                        required property var modelData

                        width: 220
                        height: 36
                        radius: 6

                        color: modelData.connected
                            ? Theme.foregroundColor
                            : "transparent"

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8

                            spacing: 8

                            Text {
                                text: modelData.name
                                color: Theme.textColor
                                font.pixelSize: 13

                                Layout.fillWidth: true

                                elide: Text.ElideRight
                            }

                            Text {
                                text: modelData.connected ? "Connected" : ""

                                color: Theme.textColor
                                font.pixelSize: 11
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (modelData.connected) {
                                    Network.disconnectNetwork(modelData)
                                } else {
                                    // Let NetworkManager / the desktop
                                    // handle password prompts.
                                    Network.connectToNetwork(modelData)
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: Network.availableNetworks.length === 0

                    text: "No networks found"

                    color: Theme.textColor
                    opacity: 0.6
                    font.pixelSize: 12
                }
            }
        }
    }
}
