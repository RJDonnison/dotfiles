pragma Singleton
import QtQuick

QtObject {
    property var activeMenu: null

    function open(menu) {
        activeMenu = menu
    }

    function close(menu) {
        if (activeMenu === menu) {
            activeMenu = null
        }
    }
}