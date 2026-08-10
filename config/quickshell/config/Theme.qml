pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property int barWidth: 46
  property color backgroundColor: "#262626"
  property color foregroundColor: "#55595A"
  property color textColor: "#AFAFAD"
  property color redColor: "#D16B64"
  property color accentColor: "#88C0FF"
}
