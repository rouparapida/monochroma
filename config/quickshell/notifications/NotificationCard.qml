
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

// card
Rectangle {
    id: root

    property var currentTheme
    property bool temporary: false
    property var notification: null

    property string summary: ""
    property string body: ""
    property var image: ""
    property string appIcon: ""
    property string appName: ""
    property string time: ""

    readonly property var iconSource: temporary
        ? (image || appIcon || "")
        : (image || "")

    implicitHeight: temporary
        ? 80
        : Math.max(62, cardContent.implicitHeight + 20)

    radius: 8
    color: temporary ? currentTheme.color0 : currentTheme.color2

    Timer {
        id: dismissTimer

        interval: 5000
        repeat: false

        running: root.temporary
                 && root.notification !== null
                 && root.notification.urgency
                    !== NotificationUrgency.Critical

        onTriggered: {
            if (root.notification)
                root.notification.dismiss()
        }
    }

    RowLayout {
        id: cardContent

        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        Image {
            Layout.preferredWidth: root.temporary ? 48 : 32
            Layout.preferredHeight: root.temporary ? 48 : 32
            Layout.alignment: root.temporary
                ? Qt.AlignVCenter
                : Qt.AlignTop

            source: root.iconSource
            fillMode: Image.PreserveAspectFit

            visible: source.toString() !== ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: root.temporary ? 3 : 5

            // application name and timestamp
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                visible: !root.temporary

                Text {
                    Layout.fillWidth: true

                    text: root.appName || "Notification"

                    font.family: "Inter"
                    font.pixelSize: 11
                    font.bold: true

                    color: root.currentTheme.color9
                    elide: Text.ElideRight
                }

                Text {
                    text: root.time

                    font.family: "Inter"
                    font.pixelSize: 10

                    color: root.currentTheme.color8
                }
            }

            Text {
                Layout.fillWidth: true

                text: root.summary

                font.family: "Inter"
                font.pixelSize: root.temporary ? 14 : 13
                font.bold: true

                color: root.currentTheme.color1
                elide: root.temporary
                    ? Text.ElideRight
                    : Text.ElideNone
                wrapMode: root.temporary
                    ? Text.NoWrap
                    : Text.WordWrap
            }

            Text {
                Layout.fillWidth: true

                text: root.body
                visible: text !== ""

                font.family: "Inter"
                font.pixelSize: 12

                color: root.temporary
                    ? root.currentTheme.color10
                    : root.currentTheme.color10

                wrapMode: Text.WordWrap
                elide: root.temporary
                    ? Text.ElideRight
                    : Text.ElideNone
            }
        }
    }

    // temporary popups can be dismissed by clicking them.
    MouseArea {
        anchors.fill: parent

        visible: root.temporary
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (root.notification)
                root.notification.dismiss()
        }
    }
}
