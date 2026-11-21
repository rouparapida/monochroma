import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.colors

Variants {
    id: root

    property bool active: false
    property var currentTheme: CurrentColorscheme

    // module colors
    property color backgroundColor: currentTheme.color14
    property color panelColor: root.currentTheme.color0
    property color buttonColor: "transparent"
    property color buttonHoverColor: root.currentTheme.color2
    property color buttonBorderColor: root.currentTheme.color13
    property color buttonHoverBorderColor: root.currentTheme.color6

    // module fonts
    property string iconFont: currentTheme.nerdFont
    property string textFont: currentTheme.font

    default property list<LogoutButton> buttons

    model: Quickshell.screens

    // create one panel on each screen
    PanelWindow {
        id: w

        property var modelData
        screen: modelData

        visible: root.active

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"

        // keyboard shortcuts
        contentItem {
            focus: true

            Keys.onPressed: event => {
                if (event.key == Qt.Key_Escape) {
                    root.active = false
                    event.accepted = true
                }
                else {
                    for (let i = 0; i < buttons.length; i++) {
                        let button = buttons[i];

                        if (event.key == button.keybind) {
                            root.active = false
                            button.exec()
                            event.accepted = true
                            break
                        }
                    }
                }
            }
        }

        // panel anchors
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        // logout background
        Rectangle {
            color: root.backgroundColor
            anchors.fill: parent

            // close menu when clicking outside
            MouseArea {
                anchors.fill: parent
                onClicked: root.active = false

                // session panel
                Rectangle {
                    id: sessionPanel

                    anchors.centerIn: parent

                    width: Math.min(parent.width * 0.46, 620)
                    height: content.implicitHeight + 40

                    radius: 20
                    color: root.panelColor

                    border.width: 1
                    border.color: root.buttonBorderColor

                    // prevent clicks inside the panel from closing it
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mouse.accepted = true
                    }

                    // session panel layout
                    ColumnLayout {
                        id: content

                        anchors.fill: parent
                        anchors.margins: 20

                        spacing: 15

                        // session header
                        ColumnLayout {
                            spacing: 4

                            Text {
                                text: "POWER MENU"

                                font.family: root.textFont
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                font.letterSpacing: 2

                                color: root.currentTheme.color8
                            }

                            Text {
                                text: "Choose an action"

                                font.family: root.textFont
                                font.pixelSize: 22
                                font.weight: Font.Medium

                                color: root.currentTheme.color1
                            }
                        }

                        // header divider
                        Rectangle {
                            Layout.fillWidth: true
                            height: 0.5

                            color: root.buttonBorderColor
                        }

                        // logout buttons layout
                        GridLayout {
                            Layout.fillWidth: true

                            columns: 2
                            columnSpacing: 10
                            rowSpacing: 10

                            // logout buttons
                            Repeater {
                                model: buttons

                                delegate: Rectangle {
                                    id: button

                                    required property LogoutButton modelData

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 76

                                    radius: 12
                                    color: root.buttonColor
                                    border.color: root.buttonBorderColor
                                    border.width: 1

                                    // button hover background
                                    Rectangle {
                                        anchors.fill: parent

                                        radius: parent.radius
                                        color: root.buttonHoverColor
                                        opacity: ma.containsMouse ? 1 : 0

                                        Behavior on opacity {
                                            NumberAnimation {
                                                duration: 160
                                                easing.type: Easing.OutCubic
                                            }
                                        }
                                    }

                                    // button hover border
                                    Rectangle {
                                        anchors.fill: parent

                                        radius: parent.radius
                                        color: "transparent"
                                        border.color: root.buttonHoverBorderColor
                                        border.width: 1

                                        opacity: ma.containsMouse ? 1 : 0

                                        Behavior on opacity {
                                            NumberAnimation {
                                                duration: 160
                                                easing.type: Easing.OutCubic
                                            }
                                        }
                                    }

                                    // button interaction
                                    MouseArea {
                                        id: ma

                                        anchors.fill: parent
                                        hoverEnabled: true

                                        cursorShape: Qt.PointingHandCursor

                                        onClicked: {
                                            root.active = false
                                            modelData.exec()
                                        }
                                    }

                                    // button icon and label
                                    RowLayout {
                                        anchors.fill: parent

                                        anchors.leftMargin: 18
                                        anchors.rightMargin: 12

                                        spacing: 14

                                        Text {
                                            text: modelData.icon

                                            font.family: root.iconFont
                                            font.pixelSize: 25

                                            color: root.currentTheme.color1
                                        }

                                        Text {
                                            Layout.fillWidth: true

                                            text: modelData.text

                                            font.family: root.textFont
                                            font.pixelSize: 14
                                            font.weight: Font.Medium

                                            color: root.currentTheme.color1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
