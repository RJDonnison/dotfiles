import QtQuick
import qs.config

Item {
    id: root

    property int weekStartDay: 1
    property int cellSize: 32
    property int gridSpacing: 2

    property var today: new Date()
    property int viewYear: today.getFullYear()
    property int viewMonth: today.getMonth()

    readonly property var monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    readonly property var dayLabels: {
        const base = ["S", "M", "T", "W", "T", "F", "S"]
        return base.slice(root.weekStartDay).concat(base.slice(0, root.weekStartDay))
    }

    property var gridCells: buildGrid()

    implicitWidth: root.cellSize * 7 + root.gridSpacing * 6
    implicitHeight: content.implicitHeight

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.today = new Date()
    }

    function buildGrid() {
        const firstOfMonth = new Date(root.viewYear, root.viewMonth, 1)
        const startOffset = (firstOfMonth.getDay() - root.weekStartDay + 7) % 7
        const gridStart = new Date(root.viewYear, root.viewMonth, 1 - startOffset)

        const cells = []
        for (let i = 0; i < 42; i++) {
            const d = new Date(gridStart)
            d.setDate(gridStart.getDate() + i)
            cells.push({
                day: d.getDate(),
                isCurrentMonth: d.getMonth() === root.viewMonth,
                isToday: d.getFullYear() === root.today.getFullYear() &&
                         d.getMonth() === root.today.getMonth() &&
                         d.getDate() === root.today.getDate()
            })
        }
        return cells
    }

    function previousMonth() {
        if (root.viewMonth === 0) {
            root.viewMonth = 11
            root.viewYear -= 1
        } else {
            root.viewMonth -= 1
        }
    }

    function nextMonth() {
        if (root.viewMonth === 11) {
            root.viewMonth = 0
            root.viewYear += 1
        } else {
            root.viewMonth += 1
        }
    }

    function goToToday() {
        root.viewYear = root.today.getFullYear()
        root.viewMonth = root.today.getMonth()
    }

    Column {
        id: content
        width: parent.width
        spacing: 8

        Row {
            id: header
            width: parent.width
            height: 24

            Text {
                width: 24
                height: 24
                text: "\u2039"
                color: Theme.textColor
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.previousMonth()
                }
            }

            Text {
                width: parent.width - 48
                height: 24
                text: root.monthNames[root.viewMonth] + " " + root.viewYear
                color: Theme.textColor
                font.bold: true
                font.pixelSize: 13
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.goToToday()
                }
            }

            Text {
                width: 24
                height: 24
                text: "\u203a"
                color: Theme.textColor
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.nextMonth()
                }
            }
        }

        Row {
            id: weekdayRow
            spacing: root.gridSpacing

            Repeater {
                model: root.dayLabels
                delegate: Text {
                    required property string modelData
                    width: root.cellSize
                    height: 20
                    text: modelData
                    color: Theme.textColor
                    opacity: 0.6
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Grid {
            id: grid
            columns: 7
            spacing: root.gridSpacing

            Repeater {
                model: root.gridCells
                delegate: Rectangle {
                    required property var modelData

                    width: root.cellSize
                    height: root.cellSize
                    radius: root.cellSize / 2
                    color: modelData.isToday ? Theme.accentColor : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: modelData.day
                        color: modelData.isToday ? Theme.backgroundColor : (modelData.isCurrentMonth ? Theme.textColor : Qt.rgba(Theme.textColor.r, Theme.textColor.g, Theme.textColor.b, 0.35))
                        font.pixelSize: 12
                        font.bold: modelData.isToday
                    }
                }
            }
        }
    }
}
