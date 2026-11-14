import Quickshell
import QtQuick

Rectangle {
    id: root

    // configuration
    property string iconGlyph: ""
    property string iconFont: "JetbrainsMono Nerd Font Propo"
    property color iconColor: "#ffffff"
    property int iconSize: 13

    implicitHeight: 18
    implicitWidth: 18

    color: "transparent"

    Text {
        anchors.centerIn: parent

        text: root.iconGlyph
        color: iconColor

        font {
            family: iconFont
            pixelSize: root.iconSize
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached([
                "rofi",
                "-show",
                "drun",
                "-show-icons"
            ])
        }
    }
}
