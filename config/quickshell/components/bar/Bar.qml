import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import qs.colors
import qs.components.bar.modules

PanelWindow {
    id: config

    // configuration
    property var currentTheme: CurrentColorscheme

    property int barHeight: 30
    property int horizontalPadding: 12
    property int moduleSpacing: 10

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
        left: 100
        right: 100
    }

    implicitHeight: barHeight
    color: "transparent"

    // left corner wing
    Shape {
        x: -config.margins.left
        y: 0
    
        width: config.margins.left
        height: config.barHeight
    
        ShapePath {
            fillColor: config.currentTheme.color0
            strokeWidth: 0
    
            startX: 0
            startY: 0
    
            PathLine {
                x: 100
                y: 0
            }
    
            PathLine {
                x: 100
                y: config.barHeight
            }
    
            PathCubic {
                x: 70
                y: 0
                control1X: 100
                control1Y: 10
                control2X: 90
                control2Y: 0
            }
    
            PathLine {
                x: 0
                y: 0
            }
        }
    }
    
    // right corner wing
    Shape {
        x: config.width
        y: 0
    
        width: config.margins.right
        height: config.barHeight
    
        ShapePath {
            fillColor: config.currentTheme.color0
            strokeWidth: 0
    
            startX: 0
            startY: 0
    
            PathLine {
                x: config.margins.right
                y: 0
            }
    
            PathLine {
                x: config.margins.right
                y: 0
            }
    
            PathCubic {
                x: 0
                y: config.barHeight
                control1X: 10
                control1Y: 0
                control2X: 0
                control2Y: 10
            }
        }
    }

    // bar body
    Rectangle {
        id: barBody

        anchors.fill: parent

        color: config.currentTheme.color0
        radius: 0
        bottomLeftRadius: height / 2
        bottomRightRadius: height / 2

        // left modules
        RowLayout {
            id: leftModules

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: config.horizontalPadding
            }

            spacing: config.moduleSpacing

            Search {}

            Rectangle {
                width: 1
                height: 14
                color: config.currentTheme.color6
            }

            Workspaces {}

            Rectangle {
                width: 1
                height: 14
                color: config.currentTheme.color6
            }

            Tray {
                panelWindow: config
            }
        }

        // center modules
        RowLayout {
            id: centerModules

            anchors.centerIn: parent

            spacing: config.moduleSpacing

            Clock {}
        }

        // right modules
        RowLayout {
            id: rightModules

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: config.horizontalPadding
            }

            spacing: config.moduleSpacing

            Network {}

            Volume {}

            Notifications {}

            Battery {}

            Rectangle {
                width: 1
                height: 14
                color: config.currentTheme.color6
            }

            Power {}
        }
    }
}