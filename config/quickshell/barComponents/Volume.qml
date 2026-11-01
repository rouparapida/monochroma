
import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property color mutedColor: "#88ffffff"
    property string iconFont: "Jetbrains Mono Nerd Font Propo"

    property int volumeLevel: -1
    property bool muted: false

    implicitHeight: 18
    implicitWidth: icon.implicitWidth
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: "transparent"

    // volume check process
    Process {
        id: volumeCheck

        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text
                const match = output.match(/Volume:\s*([0-9.]+)/)

                if (match)
                    root.volumeLevel =
                        Math.round(parseFloat(match[1]) * 100)

                root.muted = output.includes("[MUTED]")
            }
        }
    }

    // update volume periodically
    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            if (!volumeCheck.running)
                volumeCheck.running = true
        }
    }

    Text {
        id: icon

        anchors.centerIn: parent

        text: {
            if (root.muted)
                return ""

            if (root.volumeLevel < 0)
                return ""

            if (root.volumeLevel <= 33)
                return ""

            if (root.volumeLevel <= 66)
                return ""

            return ""
        }

        color: root.muted
               ? root.mutedColor
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
            Quickshell.execDetached(["pavucontrol"])
        }
    }
}
