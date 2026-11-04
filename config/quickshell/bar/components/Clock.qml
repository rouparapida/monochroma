import Quickshell
import QtQuick

Row {
    anchors.verticalCenter: parent.verticalCenter
    spacing: 4

    property color textColor: "#ffffff"
    property string textFont: "Inter" 
    property string iconFont: "JetbrainsMono Nerd Font Propo" 

    Text {

        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: textColor
        font.family: textFont
        font.bold: true
        font.pixelSize: 12

        anchors.verticalCenter: parent.verticalCenter

        // picking current time
        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["qs", "ipc", "call", "calendarSidebar", "toggle"])
        }
    }
    }
}