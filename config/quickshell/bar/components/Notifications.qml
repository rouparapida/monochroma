import Quickshell
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property string iconFont: "JetbrainsMono Nerd Font Propo"

    implicitHeight: 18
    implicitWidth: icon.implicitWidth 
    width: implicitWidth
    height: implicitHeight
    radius: height / 2
    color: "transparent"

    Text {
        id: icon

        anchors.centerIn: parent

        text: ""
        color: root.textColor
        font.pixelSize: 13
        font.bold: true
        font.family: root.iconFont
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["kitty"])
        }   
    }
}