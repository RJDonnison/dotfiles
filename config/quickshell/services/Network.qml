pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking as QsNet

Singleton {
    id: root
    property var wifiDevice: null
    property var wifiNetwork: null

    readonly property real signalStrength:
        wifiNetwork ? wifiNetwork.signalStrength * 100 : 0
    readonly property bool secure:
        wifiNetwork
            ? wifiNetwork.security !== QsNet.WifiSecurityType.Open
            : false
    readonly property bool connected:
        wifiNetwork !== null

    readonly property var availableNetworks:
        wifiDevice ? wifiDevice.networks.values : []

    property string lastError: ""

    function isSecure(network) {
        return network.security !== QsNet.WifiSecurityType.Open
    }

    function needsPassword(network) {
        return isSecure(network) && !network.known
    }

    function connectToNetwork(network, password) {
      lastError = ""

      try {
          network.connect()
      } catch (e) {
          lastError = e.toString()
      }
    }

    function disconnectNetwork(network) {
        network.disconnect()
    }

    function update() {
        let newDevice = null
        let newNetwork = null
        for (const device of QsNet.Networking.devices.values) {
            if (device.type === QsNet.DeviceType.Wifi) {
                newDevice = device
                device.scannerEnabled = true
                for (const network of device.networks.values) {
                    if (network.connected) {
                        newNetwork = network
                        break
                    }
                }
                break
            }
        }
        wifiDevice = newDevice
        wifiNetwork = newNetwork
    }

    Connections {
        target: QsNet.Networking.devices
        function onObjectInsertedPost() { root.update() }
        function onObjectRemovedPost() { root.update() }
    }

    // Listen to the *model's* insert/remove, not a "networksChanged" signal —
    // ObjectModel's own reference never changes, only its contents
    Connections {
        target: root.wifiDevice ? root.wifiDevice.networks : null
        enabled: root.wifiDevice !== null
        function onObjectInsertedPost() { root.update() }
        function onObjectRemovedPost() { root.update() }
      }

    Connections {
        target: Network

        function onSignalStrengthChanged() {
          root.update()
        }

        function onSecureChanged() {
          root.update()
        }
    }

    Repeater {
        model: root.wifiDevice ? root.wifiDevice.networks.values : []
        Connections {
            target: modelData
            function onConnectedChanged() { root.update() }
            function onSignalStrengthChanged() { root.update() }
        }
    }

    Component.onCompleted: update()
}
