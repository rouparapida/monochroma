import Quickshell
import QtQuick
import qs.colors

Item {
    id: root

    property var currentTheme: CurrentColorscheme

    implicitWidth: clockRow.implicitWidth
    implicitHeight: clockRow.implicitHeight

    Row {
        id: clockRow

        anchors.centerIn: parent
        spacing: 8

        // current time
        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: Qt.formatDateTime(clock.date, "hh:mm")

            color: root.currentTheme.color1

            font.family: root.currentTheme.font
            font.pixelSize: 11
            font.weight: Font.Bold
        }

        // separator
        Rectangle {
            width: 1
            height: 11

            anchors.verticalCenter: parent.verticalCenter

            color: root.currentTheme.color6
        }

        // current date
        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: Qt.formatDateTime(clock.date, "dddd, dd MMM")

            color: root.currentTheme.color1

            font.family: root.currentTheme.font
            font.pixelSize: 11
            font.weight: Font.Medium

            font.capitalization: Font.AllUppercase
            font.letterSpacing: 0.4
        }
    }

    // pick current date
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
