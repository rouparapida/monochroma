import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.themes
import qs.bar.components

PanelWindow {
    id: bar

    // bar config
    property int componentBorderMargins: 12
    property int componentSpacing: 8
    property int cornerWing: 16

    property var currentTheme: Monochrome

    implicitHeight: 31
    color: "transparent"

    anchors {
        top: true 
        left: true 
        right: true
    }

    margins {
        left: 400
        right: 400
        top: 4
    }

    Item {
        anchors.fill: parent

        // bar shape
        Rectangle {
            id: barBody

            anchors.fill: parent
            width: parent.width - (bar.cornerWing * 2)
            height: parent.height

            color: currentTheme.color0
            radius: height / 2
        }

        // left modules
        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: bar.componentBorderMargins
            }

            spacing: bar.componentSpacing

            Workspaces {
                anchors.verticalCenter: parent.verticalCenter

                focusedBg: currentTheme.color1
                focusedText: currentTheme.color0
                unfocusedText: currentTheme.color9
                textFont: currentTheme.font
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: "|"
                color: currentTheme.color8
                font.family: currentTheme.nerdFont
            }

            Notifications {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                iconFont: currentTheme.font
            }
        }

        // center modules
        RowLayout {
            anchors.centerIn: parent
            spacing: bar.componentSpacing

            Clock {
                anchors.verticalCenter: parent.verticalCenter   
                textColor: currentTheme.color1
                textFont: currentTheme.font
            }
        }

        // right modules
        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: bar.componentBorderMargins
            }

            spacing: bar.componentSpacing

            Tray {
                anchors.verticalCenter: parent.verticalCenter

                panelWindow: bar
                pillColor: currentTheme.color3
                iconSize: 16
                iconSpacing: 7
            }

            Network {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                noConnectionColor: currentTheme.color8
                iconFont: currentTheme.nerdFont
            }

            Volume {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                mutedColor: currentTheme.color8
                iconFont: currentTheme.font
            }

            Brightness {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                lowBrightnessColor: currentTheme.color8
                iconFont: currentTheme.nerdFont
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: "|"
                color: currentTheme.color8
                font.family: currentTheme.nerdFont
            }

            Battery {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                textFont: currentTheme.font
                iconFont: currentTheme.nerdFont
            }

            Power {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.color1
                iconFont: currentTheme.font
            }
        }
    }
}