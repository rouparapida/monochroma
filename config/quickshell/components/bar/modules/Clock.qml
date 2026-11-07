import Quickshell
import QtQuick

// clock configuration
Rectangle {
    property color textColor: "#ffffff"
    property string textFont: "Inter" 

    implicitHeight: 18
    implicitWidth: text.implicitWidth 
    width: implicitWidth
    height: implicitHeight
    color: "transparent"

    Text {
        id: text

        anchors.centerIn: parent

        text: Qt.formatDateTime(clock.date, "hh:mm")
        color: textColor
        font.family: textFont
        font.bold: true
        font.pixelSize: 11
    }

    // pick current time
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}