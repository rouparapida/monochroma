import Quickshell
import Quickshell.Io
import QtQuick

Row {
    id: root

    anchors.verticalCenter: parent.verticalCenter
    spacing: 7

    property color textColor: "#ffffff"
    property color barColor: "#ffffff"
    property color trackColor: "#303030"
    property string textFont: "Inter"

    property int cpuUsage: 0
    property int ramUsage: 0

    property real previousTotal: 0
    property real previousIdle: 0

    function updateCpu() {
        const line = cpuFile.text().trim().split("\n")[0]
        if (!line) return

        const values = line.trim()
            .split(/\s+/)
            .slice(1)
            .map(Number)

        if (values.length < 8) return

        const total = values.slice(0, 8)
            .reduce((a, b) => a + b, 0)

        const idle = values[3] + values[4]

        if (previousTotal > 0) {
            const totalDiff = total - previousTotal
            const idleDiff = idle - previousIdle

            if (totalDiff > 0) {
                cpuUsage = Math.max(0, Math.min(100,
                    Math.round(100 * (1 - idleDiff / totalDiff))
                ))
            }
        }

        previousTotal = total
        previousIdle = idle
    }

    function updateRam() {
        const content = memFile.text()

        const totalMatch = content.match(/^MemTotal:\s+(\d+)/m)
        const availableMatch = content.match(/^MemAvailable:\s+(\d+)/m)

        if (!totalMatch || !availableMatch) return

        const total = Number(totalMatch[1])
        const available = Number(availableMatch[1])

        if (total > 0) {
            ramUsage = Math.max(0, Math.min(100,
                Math.round((total - available) / total * 100)
            ))
        }
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onLoaded: root.updateCpu()
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: root.updateRam()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            cpuFile.reload()
            memFile.reload()
        }
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: "CPU"
        color: root.textColor
        font.family: root.textFont
        font.pixelSize: 9
        font.weight: Font.DemiBold
    }

    // CPU bar
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: 42
        height: 5

        color: root.trackColor
        radius: 3

        Rectangle {
            width: parent.width * root.cpuUsage / 100
            height: parent.height
            color: root.barColor
            radius: 3

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // CPU percentage
    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: root.cpuUsage + "%"
        color: root.textColor
        font.family: root.textFont
        font.pixelSize: 9
        font.weight: Font.Bold
    }

    // Separator
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter

        width: 1
        height: 12
        color: "transparent"
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: "RAM"
        color: root.textColor
        font.family: root.textFont
        font.pixelSize: 9
        font.weight: Font.DemiBold
    }

    // RAM bar
    Rectangle {
        width: 42
        height: 5
        color: root.trackColor
        radius: 3

        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            width: parent.width * root.ramUsage / 100
            height: parent.height
            color: root.barColor
            radius: 3

            Behavior on width {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // RAM percentage
    Text {
        text: root.ramUsage + "%"
        color: root.textColor
        font.family: root.textFont
        font.pixelSize: 9
        font.weight: Font.Bold
        anchors.verticalCenter: parent.verticalCenter
    }
}
