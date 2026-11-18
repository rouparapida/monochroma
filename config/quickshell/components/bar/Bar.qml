import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.colors
import qs.components.bar.modules

PanelWindow {
    id: config

    // configuration
    property var currentTheme: CurrentColorscheme

    property int barHeight: 28
    property int pillHeight: 28
    property int pillPadding: 12
    property int modulesBorderMargins: 12
    property int moduleSpacing: 10

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 4
        left: 0
        right: 0
    }

    implicitHeight: barHeight
    color: "transparent"

    // bar background
    Rectangle {
        id: barBody

        anchors.fill: parent
        color: "transparent"
        radius: 0

        // left pill
        Rectangle {
            id: leftPill

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: config.modulesBorderMargins
            }

            width: leftModules.implicitWidth + config.pillPadding * 2
            height: config.pillHeight

            color: config.currentTheme.color0
            radius: height / 2

            border.width: 1
            border.color: config.currentTheme.color13

            // grow from left to right
            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                id: leftModules

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: config.pillPadding
                }

                spacing: config.moduleSpacing

                Search {}

                Rectangle {
                    width: 1
                    height: 11

                    anchors.verticalCenter: parent.verticalCenter

                    color: config.currentTheme.color6
                }

                Workspaces {}

                Rectangle {
                    width: 1
                    height: 11

                    anchors.verticalCenter: parent.verticalCenter

                    color: config.currentTheme.color6
                }

                Tray {
                    panelWindow: config
                }
            }
        }

        // center pill
        Rectangle {
            id: centerPill

            anchors.centerIn: parent

            width: centerModules.implicitWidth + config.pillPadding * 2
            height: config.pillHeight

            color: config.currentTheme.color0
            radius: height / 2

            border.width: 1
            border.color: config.currentTheme.color13

            // grow from both sides
            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                id: centerModules

                anchors.centerIn: parent
                spacing: config.moduleSpacing

                Clock {}
            }
        }

        // right pill
        Rectangle {
            id: rightPill

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: config.modulesBorderMargins
            }

            width: rightModules.implicitWidth + config.pillPadding * 2
            height: config.pillHeight

            color: config.currentTheme.color0
            radius: height / 2

            border.width: 1
            border.color: config.currentTheme.color13

            // grow from right to left
            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                id: rightModules

                anchors.centerIn: parent
                spacing: config.moduleSpacing

                Media {}

                Network {}

                Volume {}

                Battery {}

                Rectangle {
                    width: 1
                    height: 11

                    anchors.verticalCenter: parent.verticalCenter

                    color: config.currentTheme.color6
                }

                Power {}
            }
        }
    }
}