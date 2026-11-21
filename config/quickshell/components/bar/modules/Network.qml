import QtQuick
import Quickshell
import Quickshell.Networking
import qs.colors

Item {
    id: root

    property var currentTheme: CurrentColorscheme

    readonly property var devices: Networking.devices.values

    // checks whether any Wi-Fi device is connected
    readonly property bool wifiConnected: {
        return devices.some(device =>
            device.type === DeviceType.Wifi && device.connected
        )
    }

    // checks whether any non-Wi-Fi device is connected
    readonly property bool ethernetConnected: {
        return devices.some(device =>
            device.type !== DeviceType.Wifi && device.connected
        )
    }

    // selects the network icon
    readonly property string wifiIcon: {
        if (ethernetConnected)
            return "󰈀"

        if (wifiConnected)
            return ""

        return ""
    }

    implicitWidth: wifiIconText.implicitWidth
    implicitHeight: wifiIconText.implicitHeight

    // icon
    Text {
        id: wifiIconText

        anchors.centerIn: parent

        text: root.wifiIcon

        font.family: root.currentTheme.nerdFont
        font.pixelSize: 12
        font.bold: true

        color: root.currentTheme.color1
    }

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached([
                "kitty",
                "-e",
                "nmtui",
            ])
        }
    }
}