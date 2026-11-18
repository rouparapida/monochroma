import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    // used to position system tray context menus
    property var panelWindow

    // checks whether any system tray items are available
    readonly property bool hasTrayItems: SystemTray.items.values.length > 0

    implicitWidth: contentRow.implicitWidth
    implicitHeight: contentRow.implicitHeight

    // main system tray layout
    Row {
        id: contentRow

        spacing: 6

        // creates an icon for each available system tray item
        Repeater {
            model: SystemTray.items

            delegate: IconImage {
                id: trayIcon

                required property SystemTrayItem modelData

                source: modelData.icon
                implicitSize: 16

                // handles system tray icon interactions
                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        // left click activates the selected tray item
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        // right click opens the context menu.
                        } else if (mouse.button === Qt.RightButton) {
                            if (!modelData.hasMenu || !root.panelWindow) {
                                console.log("No menu or panel window available")
                                return
                            }

                            // maps the icon position to global coordinates
                            const pos = trayIcon.mapToItem(
                                null,
                                trayIcon.width / 2,
                                trayIcon.height
                            )

                            // displays the context menu below the icon
                            modelData.display(
                                root.panelWindow,
                                pos.x,
                                pos.y
                            )
                        }
                    }
                }
            }
        }

        // empty state
        Text {
            visible: !root.hasTrayItems

            text: "No trays found"

            color: "#808080"
            font.pixelSize: 10
            font.weight: Font.Medium
            font.family: "Inter"

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}