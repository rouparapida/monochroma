import Quickshell
import QtQuick

Text {
    id: root
    property color textColor: "#737373"
    property var textFont: "JetbrainsMono Nerd Font Propo"

    anchors.verticalCenter: parent.verticalCent

    text: "|"
    color: root.textColor
    font.family: root.textFont
}