
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.colors

Scope {
    id: root

    property var currentTheme: CurrentColorscheme
    property bool shouldShowOsd: false
    property bool volumeInitialized: false

    // track the default audio sink
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // listen for volume changes
    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            if (!root.volumeInitialized) {
                root.volumeInitialized = true
                return
            }

            root.shouldShowOsd = true
            hideTimer.restart()
        }
    }

    // hide the OSD after one second
    Timer {
        id: hideTimer

        interval: 2000

        onTriggered: root.shouldShowOsd = false
    }

    // volume OSD window
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            anchors.left: true
            margins.bottom: 30
            margins.left: 450

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
                        leftMargin: 15
                        rightMargin: 15
                    }

                    spacing: 10

                    // volume icon
                    Text {
                        text: {
                            const audio = Pipewire.defaultAudioSink?.audio

                            if (!audio || audio.muted)
                                return ""

                            if (audio.volume <= 0.3)
                                return ""

                            if (audio.volume <= 0.7)
                                return ""

                            return ""
                        }

                        font {
                            family: "JetBrainsMono Nerd Font Propo"
                            pixelSize: 20
                        }

                        color: root.currentTheme.color1

                        verticalAlignment: Text.AlignVCenter
                    }

                    // volume level indicator
                    Rectangle {
                        Layout.fillWidth: true

                        implicitHeight: 6
                        radius: 20

                        color: root.currentTheme.color6

                        // current volume level
                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            implicitWidth: parent.width * (
                                Pipewire.defaultAudioSink?.audio.volume ?? 0
                            )

                            radius: parent.radius
                            color: root.currentTheme.color1
                        }
                    }
                }
            }
        }
    }
}
