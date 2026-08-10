import QtQuick
import qs.config

Item {
    id: root

    property string icon
    property color color: Theme.textColor
    property int size: 26
    property int weight: 400
    property int grade: 0

    implicitWidth: size
    implicitHeight: size

    Text {
        anchors.fill: parent

        text: root.icon

        font.family: "Material Symbols Rounded"
        font.pixelSize: root.size

        font.variableAxes: ({
            "wght": root.weight,
            "GRAD": root.grade
        })

        color: root.color

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
