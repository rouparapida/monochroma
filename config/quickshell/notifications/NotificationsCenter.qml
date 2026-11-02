
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var controller
    property var currentTheme
    property var history

    // opening and closing animations
    Connections {
        target: root.controller

        function onCenterOpenChanged() {
            if (root.controller.centerOpen) {
                root.controller.centerVisible = true
                exitAnimation.stop()
                enterAnimation.start()
            } else if (root.controller.centerVisible) {
                enterAnimation.stop()
                exitAnimation.start()
            }
        }
    }

    ParallelAnimation {
        id: enterAnimation

        NumberAnimation {
            target: panel
            property: "slideProgress"
            to: 1
            duration: 300
            easing.type: Easing.OutQuint
        }
    }

    ParallelAnimation {
        id: exitAnimation

        NumberAnimation {
            target: panel
            property: "slideProgress"
            to: 0
            duration: 300
            easing.type: Easing.InQuint
        }

        onFinished: {
            if (root.controller && !root.controller.centerOpen)
                root.controller.centerVisible = false
        }
    }

    // notification center
    PanelWindow {
        id: notificationCenter

        visible: root.controller
                 ? root.controller.centerVisible
                 : false

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay

        // clicking outside closes it
        MouseArea {
            anchors.fill: parent

            onClicked: {
                root.controller.centerOpen = false
            }
        }

        Rectangle {
            id: panel

            property real slideProgress: 0

            anchors {
                bottom: parent.bottom
                top: parent.top
                left: parent.left
            }

            width: 400
            height: 600

            radius: 0
            color: root.currentTheme.color0

            // slides the panel in from the left
            transform: Translate {
                x: -panel.width * (1 - panel.slideProgress)
                y: 0
            }

            opacity: panel.slideProgress

            // prevents clicks inside the panel from closing it
            MouseArea {
                anchors.fill: parent
            }

            ColumnLayout {
                id: centerCol

                anchors {
                    fill: parent
                    leftMargin: 16
                    topMargin: 16
                    bottomMargin: 16
                    rightMargin: 8
                }

                spacing: 14

                // header
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    ColumnLayout {
                        spacing: 3

                        Text {
                            text: "Notifications"

                            font.family: "Inter"
                            font.pixelSize: 26
                            font.bold: true

                            color: root.currentTheme.color1
                        }

                        Text {
                            text: root.history.count === 1
                                  ? "1 notification"
                                  : root.history.count + " notifications"

                            font.family: "Inter"
                            font.pixelSize: 11

                            color: root.currentTheme.color8
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        id: clearButton

                        implicitWidth: clearLabel.implicitWidth + 20
                        implicitHeight: 30

                        radius: 8

                        color: clearMouse.containsMouse
                               ? root.currentTheme.color12
                               : root.currentTheme.color1

                        visible: root.history.count > 0

                        Text {
                            id: clearLabel

                            anchors.centerIn: parent

                            text: "Clear all"

                            font.family: "Inter"
                            font.bold: true
                            font.pixelSize: 11

                            color: root.currentTheme.color0
                        }

                        MouseArea {
                            id: clearMouse

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.history.clear()
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1

                    color: root.currentTheme.color4
                }

                // notification history
                ListView {
                    id: historyList

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    spacing: 8

                    model: root.history

                    delegate: NotificationCard {
                        width: historyList.width

                        currentTheme: root.currentTheme
                        temporary: false

                        summary: model.summary
                        body: model.body
                        image: model.image
                        appName: model.appName
                        time: model.time
                    }
                }

                // empty state
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    spacing: 8
                    visible: root.history.count === 0

                    Item {
                        Layout.fillHeight: true
                    }

                    Text {
                        Layout.fillWidth: true

                        text: "No notifications"

                        font.family: "Inter"
                        font.pixelSize: 18
                        font.bold: true

                        color: root.currentTheme.color9
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        Layout.fillWidth: true

                        text: ":("

                        font.family: "Inter"
                        font.pixelSize: 14

                        color: root.currentTheme.color8
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Item {
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
