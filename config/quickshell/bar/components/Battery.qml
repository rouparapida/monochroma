
import Quickshell
import QtQuick
import Quickshell.Io

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property string textFont: "Inter" 
    property string iconFont: "JetbrainsMono Nerd Font Propo" 

    property int batteryLevel: 0
    property bool chargerConnected: false

    property string iconFull: ""
    property string iconHigh: ""
    property string iconMedium: ""
    property string iconLow: ""
    property string iconEmpty: ""
    property string iconPlug: ""

    anchors.verticalCenter: parent.verticalCenter

    implicitHeight: bat.implicitHeight
    implicitWidth: bat.implicitWidth

    color: "transparent"

    // choose the appropriate icon
    function updateBatteryIcon() {
        if (root.chargerConnected) {
            return root.iconPlug
        }

        if (root.batteryLevel >= 80) {
            return root.iconFull
        }

        if (root.batteryLevel >= 60) {
            return root.iconHigh
        }

        if (root.batteryLevel >= 40) {
            return root.iconMedium
        }

        if (root.batteryLevel >= 20) {
            return root.iconLow
        }

        return root.iconEmpty
    }

    Process {
        id: batteryProcess

        // read the current battery percentage
        command: [
            "sh", "-c",
            "cat /sys/class/power_supply/BAT0/capacity"
        ]

        stdout: StdioCollector {
            onStreamFinished: {

                // convert the value to an integer
                let level = parseInt(text.trim())

                if (!isNaN(level))
                    root.batteryLevel = level
            }
        }

        Component.onCompleted: running = true
    }

    Process {
        id: powerProcess

        // check for an external power source
        command: [
            "sh", "-c",
            "for supply in /sys/class/power_supply/*; do " +
            "[ -f \"$supply/online\" ] || continue; " +
            "[ \"$(cat \"$supply/type\" 2>/dev/null)\" = \"Battery\" ] && continue; " +
            "[ \"$(cat \"$supply/online\" 2>/dev/null)\" = \"1\" ] && { echo 1; exit 0; }; " +
            "done; echo 0"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                // check whether the charger is connected
                root.chargerConnected = text.trim() === "1"
            }
        }

        Component.onCompleted: running = true
    }

    Row {
        id: bat

        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: root.updateBatteryIcon()
            color: textColor
            font.family: iconFont
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: root.batteryLevel + "%"
            color: textColor
            font.family: textFont
            font.bold: true
            font.pixelSize: 11
        }
    }

    //update connection type every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true

        onTriggered: {
            batteryProcess.running = true
            powerProcess.running = true
        }
    }
}
