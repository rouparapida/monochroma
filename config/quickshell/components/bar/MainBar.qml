import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.components.bar.modules

PanelWindow {
    id: config

    // bar configuration
    property int barHeight: 30
    property int modulesBorderMargins: 12
    property int moduleSpacing: 10

    property var currentTheme: Monochroma

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 4
        left: 50
        right: 50
    }

    implicitHeight: barHeight
    exclusiveZone: barHeight

    color: "transparent"

    // only the actual bar receives pointer input
    mask: Region {
        item: barBackground
    }

    // main bar
    Rectangle {
        id: barBackground

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: config.barHeight
        color: config.currentTheme.color0
        radius: height / 2
        z: 1

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

            Modules {
                textColor: currentTheme.color1
                iconFont: currentTheme.nerdFont
                itemSpacing: 8
            }

            Battery {
                textColor: config.currentTheme.color1
                textFont: config.currentTheme.font
            }

            Power {}
        }
    }
}