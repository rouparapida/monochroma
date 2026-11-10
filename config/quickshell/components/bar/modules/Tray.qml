
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick

Row {
    id: root

    // config
    property var panelWindow: null

    property int iconSize: 16
    property int iconSpacing: 6
    property int menuOffset: 6

    property color hoverColor: "#252525"
    property int hoverRadius: 5

    spacing: iconSpacing

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: entry

            required property var modelData

            width: root.iconSize
            height: root.iconSize

            Rectangle {
                anchors.fill: parent
                radius: root.hoverRadius
                color: root.hoverColor

                opacity: mouseArea.containsMouse ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }

            // icon
            Image {
                anchors.fill: parent

                source: entry.modelData.icon

                sourceSize.width: root.iconSize
                sourceSize.height: root.iconSize

                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: true
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                acceptedButtons:
                    Qt.LeftButton |
                    Qt.MiddleButton |
                    Qt.RightButton

                // process clicks
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

                function openMenu() {
                    const item = entry.modelData

                    if (!item.hasMenu || !root.panelWindow)
                        return

                    const pos = entry.mapToItem(
                        null,
                        0,
                        entry.height + root.menuOffset
                    )

                    item.display(
                        root.panelWindow,
                        Math.round(pos.x),
                        Math.round(pos.y)
                    )
                }
            }
        }
    }
}
