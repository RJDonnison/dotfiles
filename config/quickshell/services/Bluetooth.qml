pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Bluetooth as QsBt

Singleton {
    id: root
    readonly property var adapter:
        QsBt.Bluetooth.defaultAdapter
    readonly property bool available:
        adapter !== null
    readonly property bool enabled:
        adapter ? adapter.enabled : false
    readonly property var devices:
        QsBt.Bluetooth.devices
    readonly property var connectedDevices:
        devices.values.filter(d => d.state === QsBt.BluetoothDeviceState.Connected)
    readonly property bool connected:
        connectedDevices.length > 0
    readonly property int deviceCount:
        devices.values.length
    readonly property var knownDevices:
        adapter ? adapter.devices.values.filter(d => d.paired) : []
    function toggleEnabled() {
        if (adapter)
            adapter.enabled = !adapter.enabled
    }
}
