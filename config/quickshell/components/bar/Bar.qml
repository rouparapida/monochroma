import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.components.bar.modules

PanelWindow {
    id: config

    // configuration
    property var currentTheme: Monochroma
    
    property int barHeight: 30
    property int modulesBorderMargins: 12
    property int moduleSpacing: 10

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
        left: 150
        right: 150
    }

    implicitHeight: barHeight
    color: "transparent"

    // bar body
    Rectangle {
        id: barBody

        anchors.fill: parent
        height: config.barheight
        color: config.currentTheme.color0
        radius: 0
        bottomLeftRadius: height / 2
        bottomRightRadius: height / 2

        // left modules
        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: config.modulesBorderMargins
            }

            spacing: config.moduleSpacing

            Search {}

            Workspaces {
                focusedBg: config.currentTheme.color1
                unfocusedBg: config.currentTheme.color8
                emptyBg: config.currentTheme.color4
            }
        }

        RowLayout {
            anchors.centerIn: parent
            spacing: config.moduleSpacing

            Clock {
                textColor: config.currentTheme.color1
                textFont: config.currentTheme.font
            }
        }

        // right modules
        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: config.modulesBorderMargins
            }

            spacing: config.moduleSpacing

            Battery {
                textColor: config.currentTheme.color1
                textFont: config.currentTheme.font
            }

            Power {}
        }
    }
}