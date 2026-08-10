import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import QtQuick
import Quickshell.Widgets
import Quickshell.Bluetooth as QsBt
import qs.config
import qs.utils
import qs.services

Item {
  id: root
  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight
  MaterialIcon {
    id: icon
    icon: Icons.getBluetoothIcon(Bluetooth.connected, Bluetooth.enabled)
    size: 22
    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: popup.menuVisible = !popup.menuVisible
    }
  }
  PopupMenu {
    id: popup
    anchorItem: icon
    onCloseRequested: menuVisible = false
    Column {
      spacing: 10
      padding: 6
      Item {
        width: 200
        height: 22
        Text {
          text: "Bluetooth"
          color: Theme.textColor
          font.pixelSize: 14
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left
        }
        Rectangle {
          id: toggle
          width: 40
          height: 22
          radius: 11
          anchors.verticalCenter: parent.verticalCenter
          anchors.right: parent.right
          color: Bluetooth.enabled ? Theme.textColor : Theme.foregroundColor
          Rectangle {
            width: 18
            height: 18
            radius: 9
            color: Theme.backgroundColor
            y: (parent.height - height) / 2
            x: Bluetooth.enabled ? parent.width - width - 1 : 1
            Behavior on x { NumberAnimation { duration: 120 } }
          }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Bluetooth.toggleEnabled()
          }
        }
      }
      Column {
        width: 200
        spacing: 4
        visible: Bluetooth.enabled
        Repeater {
          model: Bluetooth.knownDevices
          Rectangle {
            required property var modelData
            width: 200
            height: 36
            radius: 6
            color: modelData.state === QsBt.BluetoothDeviceState.Connected
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
                text: modelData.state === QsBt.BluetoothDeviceState.Connecting
                      || modelData.state === QsBt.BluetoothDeviceState.Disconnecting
                      ? "…"
                      : (modelData.state === QsBt.BluetoothDeviceState.Connected ? "Connected" : "Connect")
                color: Theme.textColor
                font.pixelSize: 12
              }
            }
            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: {
                if (modelData.state === QsBt.BluetoothDeviceState.Connected)
                  modelData.disconnect()
                else
                  modelData.connect()
              }
            }
          }
        }
        Text {
          visible: Bluetooth.knownDevices.length === 0
          text: "No paired devices"
          color: Theme.textColor
          opacity: 0.6
          font.pixelSize: 12
        }
      }
    }
  }
}
