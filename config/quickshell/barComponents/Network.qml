
import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property color noConnectionColor: "#88ffffff"
    property string iconFont: "JetbrainsMono Nerd Font Propo"

    // connection type
    property string connectionType: "none"

    implicitHeight: 18
    implicitWidth: icon.implicitWidth
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: "transparent"

    // verify connection type
    Process {
        id: networkCheck

        command: ["nmcli", "-t", "-f", "TYPE,STATE", "device", "status"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text

                if (/^ethernet:connected$/m.test(output)) {
                    root.connectionType = "ethernet"
                }

                else if (/^wifi:connected$/m.test(output)) {
                    root.connectionType = "wifi"
                }

                else {
                    root.connectionType = "none"
                }
            }
        }
    }

    // update connection type every 5 seconds
    Timer {
        interval: 5000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if (!networkCheck.running)
                networkCheck.running = true
        }
    }

    Text {
        id: icon

        anchors.centerIn: parent

        // chose icon based on connection type
        text: {
            switch (root.connectionType) {
                case "wifi":
                    return ""

                case "ethernet":
                    return "󰈀"

                default:
                    return ""
            }
        }

        color: root.connectionType === "none"
               ? root.noConnectionColor
               : root.textColor

        font.pixelSize: 13
        font.bold: true
        font.family: root.iconFont

        Behavior on color {
            ColorAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["kitty", "-e", "nmtui"])
        }
    }
}
