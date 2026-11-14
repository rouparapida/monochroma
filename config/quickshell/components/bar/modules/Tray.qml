import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    property var panelWindow

    implicitWidth: trayRow.implicitWidth
    implicitHeight: trayRow.implicitHeight

    Row {
        id: trayRow

        spacing: 4

        Repeater {
            model: SystemTray.items

            delegate: IconImage {
                id: trayIcon

                required property SystemTrayItem modelData

                source: modelData.icon
                implicitSize: 16

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        }

                        else if (mouse.button === Qt.RightButton) {
                            if (!modelData.hasMenu || !root.panelWindow) {
                                console.log("No menu or panel window available")
                                return
                            }

                            const pos = trayIcon.mapToItem(
                                null,
                                trayIcon.width / 2,
                                trayIcon.height
                            )

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
    }
}