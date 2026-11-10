
import Quickshell
import QtQuick

Rectangle {
    id: root

    property color textColor: "#ffffff"
    property string iconFont: "JetbrainsMono Nerd Font Propo"
    property int itemSpacing: 8

    implicitHeight: 18
    implicitWidth: content.implicitWidth
    color: "transparent"

    Row {
        id: content

        anchors.centerIn: parent
        spacing: root.itemSpacing

        Text {
            text: ""
            color: root.textColor
            font.pixelSize: 12
            font.bold: true 
            font.family: root.iconFont

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Quickshell.execDetached(["kitty", "-e", "nmtui"])
                }
            }
        }

        Text {
            text: ""
            color: root.textColor
            font.pixelSize: 12
            font.bold: true 
            font.family: root.iconFont

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
        
                onClicked: {
                    Quickshell.execDetached(["pavucontrol"])
                }
            }
        }

        Text {
            text: "󰃠" 
            color: root.textColor
            font.pixelSize: 12
            font.bold: true 
            font.family: root.iconFont
        }

        Text {
            text: "" 
            color: root.textColor
            font.pixelSize: 12
            font.bold: true 
            font.family: root.iconFont
        }
    }
}
