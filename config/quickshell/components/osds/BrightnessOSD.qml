
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.colors

Scope {
    id: root

    property var currentTheme: CurrentColorscheme

    property real currentBrightness: 0
    property bool initialized: false
    property bool shouldShowOsd: false

    // monitor brightness changes
    Process {
        id: brightnessProcess

        command: ["brightnessctl", "-m"]

        stdout: StdioCollector {
            onStreamFinished: {
                const output = text.trim().split(",")

                if (output.length < 5)
                    return

                const percentage = parseInt(output[3], 10)

                if (isNaN(percentage))
                    return

                const newBrightness = percentage / 100

                if (!root.initialized) {
                    root.currentBrightness = newBrightness
                    root.initialized = true
                    return
                }

                if (root.currentBrightness !== newBrightness) {
                    root.currentBrightness = newBrightness
                    root.shouldShowOsd = true
                    hideTimer.restart()
                }
            }
        }
    }

    // poll brightness every 250ms
    Timer {
        interval: 250
        running: true
        repeat: true

        onTriggered: {
            if (!brightnessProcess.running)
                brightnessProcess.running = true
        }
    }

    // hide the OSD after one second
    Timer {
        id: hideTimer

        interval: 2000

        onTriggered: root.shouldShowOsd = false
    }

    // brightness OSD window
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            anchors.right: true
            margins.bottom: 30
            margins.right: 450

            exclusiveZone: 0

            implicitWidth: 300
            implicitHeight: 40

            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent

                radius: height / 2
                color: root.currentTheme.color0

                border.width: 1
                border.color: root.currentTheme.color13

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 15
                    }

                    spacing: 10

                    // brightness icon
                    Text {
                        text: {
                            if (root.currentBrightness <= 0.01)
                                return "󰃞"

                            if (root.currentBrightness < 0.35)
                                return "󰃟"

                            if (root.currentBrightness < 0.75)
                                return "󰃠"

                            return "󰃡"
                        }

                        font {
                            family: "JetBrainsMono Nerd Font Propo"
                            pixelSize: 22
                        }

                        color: root.currentTheme.color1

                        verticalAlignment: Text.AlignVCenter
                    }

                    // brightness level indicator
                    Rectangle {
                        Layout.fillWidth: true

                        implicitHeight: 6
                        radius: 20

                        color: root.currentTheme.color7

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: parent.width * root.currentBrightness

                            radius: parent.radius
                            color: root.currentTheme.color1
                        }
                    }
                }
            }
        }
    }
}
