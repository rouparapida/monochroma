import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.colors

Scope {
    id: root

    property var currentTheme: CurrentColorscheme
    property bool shouldShowOsd: false
    property bool volumeInitialized: false

    // Track the default audio sink
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Listen for volume changes
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

    // Hide the OSD after two seconds
    Timer {
        id: hideTimer

        interval: 2000

        onTriggered: root.shouldShowOsd = false
    }

    // Volume OSD window
    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            anchors.bottom: true
            anchors.left: true

            margins.bottom: 0
            margins.left: 450

            exclusiveZone: 0

            implicitWidth: 300
            implicitHeight: 40

            color: "transparent"
            mask: Region {}

            Rectangle {
                anchors.fill: parent

                radius: 0
                topLeftRadius: height / 2
                topRightRadius: height / 2

                color: root.currentTheme.color0

                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 15
                        rightMargin: 15
                    }

                    spacing: 10

                    // Volume icon
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

                    // Volume level indicator
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 0

                        implicitHeight: 6
                        radius: 20

                        color: root.currentTheme.color6

                        clip: true

                        // Current volume level
                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            width: parent.width * Math.max(
                                0,
                                Math.min(
                                    Pipewire.defaultAudioSink?.audio.volume ?? 0,
                                    1.0
                                )
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