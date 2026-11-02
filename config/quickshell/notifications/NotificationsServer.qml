
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import qs.themes

Scope {
    id: root

    property var currentTheme: Monochrome

    property bool centerOpen: false
    property bool centerVisible: false

    property alias history: historyModel

    // stores notification history
    ListModel {
        id: historyModel
    }

    NotificationServer {
        id: server

        actionsSupported: true
        bodySupported: true
        imageSupported: true

        onNotification: n => {
            historyModel.insert(0, {
                summary: n.summary,
                body: n.body,
                image: n.image,
                appName: n.appName,
                time: Qt.formatDateTime(new Date(), "hh:mm")
            })

            n.tracked = true
        }
    }

    // notification center IPC controls
    IpcHandler {
        target: "notifications"

        function toggle(): void {
            root.centerOpen = !root.centerOpen
        }

        function show(): void {
            root.centerOpen = true
        }

        function hide(): void {
            root.centerOpen = false
        }
    }

    // temporary notification popups
    PanelWindow {
        anchors {
            bottom: true
            left: true
        }

        margins.bottom: 10
        margins.left: 10

        implicitWidth: 380
        implicitHeight: Math.max(1, popupColumn.implicitHeight)

        exclusionMode: ExclusionMode.Ignore
        color: "transparent"

        visible: !root.centerVisible

        ColumnLayout {
            id: popupColumn

            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: NotificationCard {
                    required property var modelData

                    Layout.fillWidth: true
                    Layout.preferredHeight: 80

                    currentTheme: root.currentTheme
                    temporary: true

                    notification: modelData
                    summary: modelData.summary
                    body: modelData.body
                    image: modelData.image
                    appIcon: modelData.appIcon

                    appName: ""
                    time: ""
                }
            }
        }
    }

    // notification center
    NotificationsCenter {
        controller: root
        currentTheme: root.currentTheme
        history: root.history
    }
}
