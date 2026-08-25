pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var activeNotifications: []
    property var historyEntries: []
    readonly property int unreadCount: historyEntries.filter(e => !e.read).length

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true
        keepOnReload: false

        onNotification: notif => {
            notif.tracked = true
            root.activeNotifications = [...root.activeNotifications, notif]

            const entry = {
                id: notif.id,
                appName: notif.appName,
                appIcon: notif.appIcon,
                summary: notif.summary,
                body: notif.body,
                image: notif.image,
                urgency: notif.urgency,
                timestamp: Date.now(),
                read: false
            }
            root.historyEntries = [entry, ...root.historyEntries].slice(0, 100)
            root.saveHistory()

            notif.closed.connect(function (reason) {
                root.activeNotifications = root.activeNotifications.filter(n => n !== notif)
            })
        }
    }

    FileView {
        id: historyFile
        path: Quickshell.env("HOME") + "/.local/share/quickshell/notifications.json"
        blockLoading: true
        blockWrites: false
    }

    Component.onCompleted: root.loadHistory()

    function loadHistory() {
        try {
            const raw = historyFile.text()
            if (raw && raw.length > 0) {
                root.historyEntries = JSON.parse(raw)
            }
        } catch (e) {
            root.historyEntries = []
        }
    }

    function saveHistory() {
        historyFile.setText(JSON.stringify(root.historyEntries, null, 2))
    }

    function clearHistory() {
        root.historyEntries = []
        root.saveHistory()
    }

    function markAllRead() {
        root.historyEntries = root.historyEntries.map(e => Object.assign({}, e, { read: true }))
        root.saveHistory()
    }

    function dismissEntry(id) {
        root.historyEntries = root.historyEntries.filter(e => e.id !== id)
        root.saveHistory()
    }
}
