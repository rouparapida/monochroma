import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.themes
import qs.components.bar.modules

// bar configuration
PanelWindow {
    id: config
    property int modulesBorderMargins: 14
    property int moduleSpacing: 8 

    property var currentTheme: Monochroma

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 4
        left: 200
        right: 200
    }

    implicitHeight: 30
    color: "transparent"

    // main bar
    Rectangle {
        anchors.fill: parent

        color: currentTheme.color0
        radius: height / 2

        //left modules
        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: config.modulesBorderMargins
            }

            spacing: config.componentSpacing

            Clock {
                textColor: currentTheme.color1
                textFont: currentTheme.font
            }

            Separator {
                textColor: currentTheme.color8
            }

            Workspaces {
                focusedBg: currentTheme.color1
                unfocusedBg: currentTheme.color8
                emptyBg: currentTheme.color4
            }

            Tray {
                pillColor: currentTheme.color4
                iconSize: 16    
                iconSpacing: 7
            }

        }

        // right modules
        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: config.modulesBorderMargins
            }

            spacing: config.componentSpacing

            CpuRamUsage {
                textColor: currentTheme.color1
                barColor: currentTheme.color1
                trackColor: currentTheme.color6
                textFont: currentTheme.font
            }

            Separator {
                textColor: currentTheme.color8
            }

            Battery {
                textColor: currentTheme.color1
                textFont: currentTheme.font 
                iconFont: currentTheme.iconFont
            }

            Power {
                textColor: currentTheme.color1
                textFont: currentTheme.font
            }
        }
    }
}