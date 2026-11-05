import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.themes
import qs.bar.components

PanelWindow {
    id: bar

    property int componentBorderMargins: 30
    property int componentSpacing: 8

    property var currentTheme: Monochrome

    // wing configs
    property int notchSize: 16
    property real notchCurveStart: 0.448
    property real notchCurveEnd: 0.552

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

        // bar body
        Rectangle {
            id: barBody

            x: bar.notchSize
            y: -bar.notchSize

            width: parent.width - bar.notchSize * 2
            height: parent.height + bar.notchSize

            color: bar.currentTheme.color0

            radius: 0
            bottomLeftRadius: 16
            bottomRightRadius: 16
        }

        // left wing
        Shape {
            x: 0
            y: 0

            width: bar.notchSize
            height: bar.notchSize

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: leftWingPath

                readonly property real size: bar.notchSize

                strokeWidth: 0
                fillColor: bar.currentTheme.color0

                startX: 0
                startY: 0

                PathLine {
                    x: leftWingPath.size
                    y: 0
                }

                PathLine {
                    x: leftWingPath.size
                    y: leftWingPath.size
                }

                PathCubic {
                    control1X: leftWingPath.size
                    control1Y: leftWingPath.size * bar.notchCurveStart

                    control2X: leftWingPath.size * bar.notchCurveEnd
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

            width: bar.notchSize
            height: bar.notchSize

            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: rightWingPath

                readonly property real size: bar.notchSize

                strokeWidth: 0
                fillColor: bar.currentTheme.color0

                startX: rightWingPath.size
                startY: 0

                PathLine {
                    x: 0
                    y: 0
                }

                PathLine {
                    x: 0
                    y: rightWingPath.size
                }

                PathCubic {
                    control1X: 0
                    control1Y: rightWingPath.size * bar.notchCurveStart

                    control2X: rightWingPath.size * bar.notchCurveEnd
                    control2Y: 0

                    x: rightWingPath.size
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

                focusedBg: currentTheme.color1
                unfocusedBg: currentTheme.color8
                emptyBg: currentTheme.color4
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

        // center module
        RowLayout {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

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
                pillColor: currentTheme.color4
                iconSize: 15
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
