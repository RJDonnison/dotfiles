import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.modules
import qs.modules.bar

ShellRoot {
  Bar {id: sidebar}

  Notifications {
      sidebarWidth: Theme.barWidth
  }
}
