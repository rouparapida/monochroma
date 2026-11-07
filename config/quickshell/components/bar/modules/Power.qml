import Quickshell
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property string textFont: "Inter"

    implicitHeight: 18
    implicitWidth: icon.implicitWidth 
    width: implicitWidth
    height: implicitHeight
    color: "transparent"

    Text {
        id: icon
        
        anchors.centerIn: parent

        text: "Power"
        color: root.textColor
        font.pixelSize: 11
        font.weight: Font.DemiBold
        font.family: root.textFont
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["systemctl", "poweroff"])
        }
    }
}