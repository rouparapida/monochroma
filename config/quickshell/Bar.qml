import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.themes
import qs.barComponents

PanelWindow {
    id: bar

    // bar config
    property int componentBorderMargins: 33
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
        top: 0
    }

    Item {
        anchors.fill: parent

        // bar shape
        Rectangle {
            id: barBody

            x: bar.cornerWing
            y: 0
            width: parent.width - (bar.cornerWing * 2)
            height: parent.height
            color: currentTheme.background
            bottomLeftRadius: 16
            bottomRightRadius: 16
            topRightRadius: 0
            topLeftRadius: 0
        }

        // left wing
        Shape {
            x: 0
            y: 0
            width: bar.cornerWing
            height: bar.cornerWing
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: leftShoulderPath

                readonly property real size: bar.cornerWing

                strokeWidth: 0
                fillColor: currentTheme.background
                startX: 0
                startY: 0

                PathLine {
                    x: leftShoulderPath.size
                    y: 0
                }

                PathLine {
                    x: leftShoulderPath.size
                    y: leftShoulderPath.size
                }

                PathCubic {
                    control1X: leftShoulderPath.size
                    control1Y: leftShoulderPath.size * 0.448
                    control2X: leftShoulderPath.size * 0.552
                    control2Y: 0
                    x: 0
                    y: 0
                }
            }
        }

        // right wing
        Shape {
            x: parent.width - width
            y: 0
            width: bar.cornerWing
            height: bar.cornerWing
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: rightShoulderPath

                readonly property real size: bar.cornerWing

                strokeWidth: 0
                fillColor: currentTheme.background
                startX: rightShoulderPath.size
                startY: 0

                PathLine {
                    x: 0
                    y: 0
                }

                PathLine {
                    x: 0
                    y: rightShoulderPath.size
                }

                PathCubic {
                    control1X: 0
                    control1Y: rightShoulderPath.size * 0.448
                    control2X: rightShoulderPath.size * 0.448
                    control2Y: 0
                    x: rightShoulderPath.size
                    y: 0
                }
            }
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

                focusedBg: currentTheme.backgroundalt3
                focusedText: currentTheme.textalt3
                unfocusedText: currentTheme.textalt4
                textFont: currentTheme.font
            }

            Notifications {
                anchors.verticalCenter: parent.verticalCenter
                
                textColor: currentTheme.text
                iconFont: currentTheme.font
            }
        }

        // center modules
        RowLayout {
            anchors.centerIn: parent
            spacing: bar.componentSpacing

            Clock {
                anchors.verticalCenter: parent.verticalCenter   
                textColor: currentTheme.text
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
                pillColor: currentTheme.backgroundalt
                iconSize: 16
                iconSpacing: 7
            }


            Network {
                anchors.verticalCenter: parent.verticalCenter
                
                textColor: currentTheme.text
                noConnectionColor: currentTheme.textalt2
                iconFont: currentTheme.fontalt
            }

            Volume {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.text
                mutedColor: currentTheme.textalt2
                iconFont: currentTheme.font
            }

            Brightness {
                anchors.verticalCenter: parent.verticalCenter
                
                textColor: currentTheme.text
                lowBrightnessColor: currentTheme.textalt2
                iconFont: currentTheme.fontalt
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: "|"
                color: currentTheme.text
                font.family: currentTheme.fontalt
            }

            Battery {
                anchors.verticalCenter: parent.verticalCenter
                
                textColor: currentTheme.text
                textFont: currentTheme.font
                iconFont: currentTheme.fontalt
            }

            Power {
                anchors.verticalCenter: parent.verticalCenter

                textColor: currentTheme.text
                iconFont: currentTheme.font
            }

        }
    }
}
