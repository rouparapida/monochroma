import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.colors
import qs.components.bar.modules

PanelWindow {
    id: config

    // configuration
    property var currentTheme: CurrentColorscheme

    property int barHeight: 30
    property int horizontalPadding: 8
    property int moduleSpacing: 8

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

    implicitHeight: barHeight
    color: "transparent"

    // bar body
    Rectangle {
        id: barBody

        anchors.fill: parent

        color: config.currentTheme.color0
        radius: 0

        // bottom border
        Rectangle {
           anchors {
               bottom: parent.bottom
               left: parent.left
               right: parent.right
           }

           height: 1
           color: config.currentTheme.color13
        }

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

            Media {}

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