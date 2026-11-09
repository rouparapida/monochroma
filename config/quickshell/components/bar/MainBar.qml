import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.components.bar.modules

PanelWindow {
    id: config

    // bar configuration
    property int barHeight: 30
    property int curveRadius: 14
    property int modulesBorderMargins: 12
    property int moduleSpacing: 8

    property var currentTheme: Monochroma

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
        left: 0
        right: 0
    }

    implicitHeight: barHeight + curveRadius
    exclusiveZone: barHeight

    color: "transparent"

    // only the actual bar receives pointer input
    mask: Region {
        item: barBackground
    }

    // curves sit underneath the bar
    BarCurves {
        id: barCurves

        anchors {
            top: barBackground.bottom
            left: parent.left
            right: parent.right
        }

        radius: config.curveRadius
        color: config.currentTheme.color0
        z: 0
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
        radius: 0
        z: 1

        // left modules
        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: config.modulesBorderMargins
            }

            spacing: config.moduleSpacing

            Clock {
                textColor: config.currentTheme.color1
                textFont: config.currentTheme.font
            }

            Separator {
                textColor: config.currentTheme.color8
            }

            Workspaces {
                focusedBg: config.currentTheme.color1
                unfocusedBg: config.currentTheme.color8
                emptyBg: config.currentTheme.color4
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

            Separator {
                textColor: config.currentTheme.color8
            }

            CpuRamUsage {
                textColor: config.currentTheme.color1
                barColor: config.currentTheme.color1
                trackColor: config.currentTheme.color6
                textFont: config.currentTheme.font
            }

            Separator {
                textColor: config.currentTheme.color8
            }

            Battery {
                textColor: config.currentTheme.color1
                textFont: config.currentTheme.font
            }

            Power {
                textColor: config.currentTheme.color1
                iconFont: config.currentTheme.font
            }
        }
    }
}
