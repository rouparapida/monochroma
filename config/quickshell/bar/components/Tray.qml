
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Rectangle {
    id: root

    property var panelWindow

    property color pillColor: "#14ffffff"

    property int iconSize: 16
    property int iconSpacing: 7

    property int horizontalPadding: 8
    property int verticalPadding: 4

    implicitWidth: trayContent.implicitWidth + horizontalPadding * 2
    implicitHeight: iconSize + verticalPadding * 1

    width: implicitWidth
    height: implicitHeight

    radius: height / 2
    color: pillColor

    visible: SystemTray.items.values.length > 0

    Row {
        id: trayContent

        anchors.centerIn: parent

        spacing: root.iconSpacing

        // pick up all the applications registered in the SystemTray
        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: entry

                required property var modelData

                implicitWidth: root.iconSize
                implicitHeight: root.iconSize

                width: implicitWidth
                height: implicitHeight

                // app icon
                Image {
                    anchors.fill: parent

                    source: entry.modelData.icon

                    sourceSize {
                        width: root.iconSize
                        height: root.iconSize
                    }

                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    asynchronous: true
                }

                MouseArea {
                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons:
                        Qt.LeftButton |
                        Qt.MiddleButton |
                        Qt.RightButton

                    // open app menu
                    function openMenu() {
                        const item = entry.modelData

                        if (!item.hasMenu || !root.panelWindow)
                            return

                        const position = root.panelWindow.itemPosition(entry)

                        item.display(
                            root.panelWindow,
                            Math.round(position.x),
                            Math.round(position.y + entry.height)
                        )
                    }

                    // icon interactions
                    onClicked: mouse => {
                        const item = entry.modelData

                        if (mouse.button === Qt.LeftButton) {
                            if (item.onlyMenu)
                                openMenu()
                            else
                                item.activate()
                        }

                        else if (mouse.button === Qt.MiddleButton) {
                            item.secondaryActivate()
                        }

                        else if (mouse.button === Qt.RightButton) {
                            openMenu()
                        }
                    }

                    onWheel: wheel => {
                        entry.modelData.scroll(
                            wheel.angleDelta.y,
                            false
                        )
                    }
                }
            }
        }
    }
}
