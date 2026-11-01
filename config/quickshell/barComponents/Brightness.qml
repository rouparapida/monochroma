
import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property color lowBrightnessColor: "#88ffffff"
    property string iconFont: "Jetbrains Mono Nerd Font Propo"

    property int brightnessLevel: -1
    property int brightnessStep: 5

    implicitHeight: 18
    implicitWidth: icon.implicitWidth
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: "transparent"

    // check current brightness level
    Process {
        id: brightnessCheck

        command: ["brightnessctl", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim()

                // extract the percentage from the output
                const match = output.match(/,([0-9]+(?:\.[0-9]+)?)%/)

                if (match) {
                    root.brightnessLevel =
                        Math.round(parseFloat(match[1]))
                }
            }
        }
    }

    // update brightness level every second
    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if (!brightnessCheck.running)
                brightnessCheck.running = true
        }
    }

    Text {
        id: icon

        anchors.centerIn: parent

        text: {
            if (root.brightnessLevel < 0)
                return "󰃠"

            if (root.brightnessLevel <= 33)
                return "󰃞"

            if (root.brightnessLevel <= 66)
                return "󰃟"

            return "󰃠"
        }

        color: root.brightnessLevel >= 0 &&
               root.brightnessLevel <= 10
               ? root.lowBrightnessColor
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

        // scroll to change brightness
        onWheel: wheel => {
            const delta = wheel.angleDelta.y > 0
                ? "+" + root.brightnessStep + "%"
                : root.brightnessStep + "%-"

            Quickshell.execDetached([
                "brightnessctl",
                "set",
                delta
            ])

            wheel.accepted = true
        }
    }
}
