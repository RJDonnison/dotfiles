import Quickshell
import QtQuick
import qs.config
import qs.services
Item {
  id: root
  required property Item anchorItem
  property bool menuVisible: false
  property int gap: 12
  property real cornerRadius: 8
  property real padding: 8
  signal closeRequested()
  default property alias content: contentRow.data

  onMenuVisibleChanged: {
      if (root.menuVisible) {
          PopupState.open(root)
          popup.forceActiveFocus()
      } else {
          PopupState.close(root)
      }
  }

  Connections {
      target: PopupState
      function onActiveMenuChanged() {
          if (PopupState.activeMenu !== root && root.menuVisible) {
              root.menuVisible = false
          }
      }
  }
  PanelWindow {
    id: catcher
    visible: root.menuVisible
    exclusiveZone: 0
    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }

    MouseArea {
      anchors.fill: parent
      onClicked: { root.menuVisible = false; root.closeRequested() }
    }
  }
  PopupWindow {
    id: popup
    visible: root.menuVisible
    anchor.item: root.anchorItem
    anchor.edges: Edges.Left
    anchor.gravity: Edges.Left
    anchor.rect.x: -root.gap
    anchor.rect.y: root.anchorItem.height
    implicitWidth: contentRow.implicitWidth + root.padding * 2
    implicitHeight: contentRow.implicitHeight + root.padding * 2
    color: "transparent"
    Rectangle {
      anchors.fill: parent
      color: Theme.backgroundColor
      topLeftRadius: root.cornerRadius
      bottomLeftRadius: root.cornerRadius
      topRightRadius: 0
      bottomRightRadius: 0

      focus: true
      Keys.onEscapePressed: { root.menuVisible = false; root.closeRequested() }

      Row {
        id: contentRow
        anchors.centerIn: parent
      }
    }
  }
}
