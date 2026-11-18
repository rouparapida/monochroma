import QtQuick
import Quickshell
import Quickshell.Io
import qs.colors

Item {
    id: root

    property var currentTheme: CurrentColorscheme

    // audio output configuration
    property string defaultSinkName: ""
    property bool usingHeadphones: false

    implicitWidth: volumeIcon.implicitWidth
    implicitHeight: volumeIcon.implicitHeight

    // Identifies the active audio output port
    function updateActivePort(output) {
        const sinkBlocks = output.split(/(?=Sink #\d+)/)
        let activeSink = null

        // find the default audio output device
        for (const sinkBlock of sinkBlocks) {
            const nameMatch = sinkBlock.match(/^\s*Name:\s*(.+)$/m)

            if (nameMatch && nameMatch[1].trim() === root.defaultSinkName) {
                activeSink = sinkBlock
                break
            }
        }

        // reset the headphone state when no matching device is found
        if (!activeSink) {
            root.usingHeadphones = false
            return
        }

        // check the active port for headphone-related identifiers
        const portMatch = activeSink.match(/^\s*Active Port:\s*(.+)$/m)

        if (portMatch) {
            const activePort = portMatch[1].trim().toLowerCase()

            root.usingHeadphones =
                /headphones|headset|earphones|earbuds|hands[-_ ]?free/.test(activePort)

            return
        }

        // fall back to device description and sink name
        const descriptionMatch = activeSink.match(/^\s*Description:\s*(.+)$/m)

        const outputInfo = [
            descriptionMatch ? descriptionMatch[1] : "",
            root.defaultSinkName
        ].join(" ").toLowerCase()

        root.usingHeadphones =
            /headphones|headset|earphones|earbuds/.test(outputInfo)
    }

    // retrieves the current default audio output device
    Process {
        id: defaultSinkProcess

        command: ["pactl", "get-default-sink"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const name = this.text.trim()

                // store the default sink and request its device information
                if (name.length > 0) {
                    root.defaultSinkName = name
                    sinkListProcess.running = true
                } else {
                    root.usingHeadphones = false
                }
            }
        }
    }

    // retrieves detailed information about available audio outputs
    Process {
        id: sinkListProcess

        command: ["pactl", "list", "sinks"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.updateActivePort(this.text)
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true

        onTriggered: {
            if (!defaultSinkProcess.running)
                defaultSinkProcess.running = true
        }
    }

    // audio output status icon
    Text {
        id: volumeIcon

        anchors.centerIn: parent

        text: root.usingHeadphones ? "" : ""

        font.family: root.currentTheme.nerdFont
        font.pixelSize: 12

        color: root.currentTheme.color1
    }
    
    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached([
                "pavucontrol",
            ])
        }
    }
}