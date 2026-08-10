import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config

Item {
    id: root

    property int iconSize: 28
    property int cellPadding: 6
    property int itemSpacing: 6
    property int pollInterval: 300
    property color hoverColor: Theme.foregroundColor
    property color activeAccent: Theme.accentColor
    property color badgeColor: Theme.accentColor

    property var ignoredClasses: ["plasmashell", "krunner", "kwin", "kwin_x11", "yakuake", "polkit-kde-authentication-agent-1"]

    property var groupedApps: []
    property string activeWindowId: ""

    implicitWidth: iconSize + cellPadding * 2
    implicitHeight: column.implicitHeight

    Process {
        id: pollProc
        command: ["sh", "-c", "wmctrl -lx; echo '___ACTIVE___'; xprop -root _NET_ACTIVE_WINDOW"]
        stdout: StdioCollector {
            onStreamFinished: root.handlePollResult(this.text)
        }
    }

    Timer {
        interval: root.pollInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!pollProc.running) pollProc.running = true;
        }
    }

    function handlePollResult(text) {
        const idx = text.indexOf("___ACTIVE___");
        const listText = idx === -1 ? text : text.slice(0, idx);
        const activeText = idx === -1 ? "" : text.slice(idx);

        root.groupedApps = root.parseWindowList(listText);

        const m = activeText.match(/#\s*(0x[0-9a-fA-F]+)/);
        root.activeWindowId = m ? root.normalizeId(m[1]) : "";
    }

    function normalizeId(hexStr) {
        return "0x" + parseInt(hexStr, 16).toString(16).padStart(8, "0");
    }

    function parseWindowList(text) {
        const lines = text.split("\n").filter(l => l.trim().length > 0);
        const byId = {};
        const order = [];

        const lineRe = /^(\S+)\s+(-?\d+)\s+(\S+)\s+(\S+)\s+(.*)$/;

        for (const line of lines) {
            const m = line.match(lineRe);
            if (!m) continue;

            const winId = root.normalizeId(m[1]);
            const desktop = parseInt(m[2]);
            const wmClass = m[3];
            const title = m[5];

            if (desktop < 0) continue;

            const parts = wmClass.split(".");
            const instance = parts[0] || wmClass;
            const className = parts[1] || parts[0] || wmClass;

            const lowerInstance = instance.toLowerCase();
            const lowerClass = className.toLowerCase();
            if (root.ignoredClasses.some(c => c === lowerInstance || c === lowerClass)) continue;

            const key = wmClass;
            if (!byId[key]) {
                let entry = DesktopEntries.heuristicLookup(instance);
                if (!entry) entry = DesktopEntries.heuristicLookup(className);

                byId[key] = {
                    appId: key,
                    instance: instance,
                    className: className,
                    iconName: entry ? entry.icon : "",
                    niceName: entry ? entry.name : className,
                    windows: []
                };
                order.push(byId[key]);
            }
            byId[key].windows.push({ id: winId, title: title });
        }

        return order;
    }

    Process {
        id: activateProc
    }

    function activateWindowId(winId) {
        activateProc.command = ["wmctrl", "-i", "-a", winId];
        activateProc.running = true;
        root.activeWindowId = winId;
    }

    function activateGroup(group) {
        const wins = group.windows;
        if (wins.length === 0) return;

        if (wins.length === 1) {
            root.activateWindowId(wins[0].id);
            return;
        }

        const curIdx = wins.findIndex(w => w.id === root.activeWindowId);
        const nextIdx = curIdx === -1 ? 0 : (curIdx + 1) % wins.length;
        root.activateWindowId(wins[nextIdx].id);
    }

    ColumnLayout {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: root.itemSpacing

        Repeater {
            model: root.groupedApps

            delegate: Item {
                id: cell
                required property var modelData

                readonly property var group: modelData
                readonly property int windowCount: group.windows.length
                readonly property bool isActive: group.windows.some(w => w.id === root.activeWindowId)

                Layout.alignment: Qt.AlignHCenter
                implicitWidth: root.iconSize + root.cellPadding * 2
                implicitHeight: root.iconSize + root.cellPadding * 2

                Rectangle {
                    visible: cell.isActive
                    width: 3
                    radius: 2
                    color: root.activeAccent
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    height: parent.height * 0.6
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: mouseArea.containsMouse ? root.hoverColor : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                IconImage {
                    id: icon
                    anchors.centerIn: parent
                    width: root.iconSize
                    height: root.iconSize
                    implicitSize: root.iconSize
                    source: Quickshell.iconPath(cell.group.iconName, "application-x-executable")
                }

                Rectangle {
                    visible: cell.windowCount > 1
                    width: 6
                    height: 6
                    radius: 3
                    color: root.badgeColor
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 4
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.activateGroup(cell.group)
                }
            }
        }
    }
}
