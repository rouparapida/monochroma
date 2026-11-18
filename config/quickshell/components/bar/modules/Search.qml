import QtQuick
import Quickshell
import qs.colors

Item {
    id: root

    property var currentTheme: CurrentColorscheme

    implicitWidth: powerIcon.implicitWidth
    implicitHeight: powerIcon.implicitHeight

    // icon
    Text {
        id: powerIcon

        anchors.centerIn: parent

        text: ""

        font.family: root.currentTheme.nerdFont
        font.pixelSize: 12

        color: root.currentTheme.color1
    }

    MouseArea {
        anchors.fill: parent

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached([
                "kitty", // Change to your search menu in the future
            ])
        }
    }
}
