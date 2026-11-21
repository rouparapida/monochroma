import QtQuick
import QtQuick.Layouts
import Quickshell

// result row configuration
Rectangle {
    id: root

    // public properties
    property var entry
    property bool selected: false
    property color foregroundColor: "#f2f2f2"
    property color selectionColor: "#303030"
    property color selectionBorderColor: "#414141"
    property string fontFamily: "Inter"
    property string iconFontFamily: "JetbrainsMono Nerd Font Propo"

    signal hovered()
    signal activated()

    // selection styling
    radius: 9
    color: selected ? selectionColor : "transparent"
    border.width: selected ? 1 : 0
    border.color: selected ? selectionBorderColor : "transparent"

    // result content layout
    RowLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 11

        // application icon
        Image {
            Layout.preferredWidth: 23
            Layout.preferredHeight: 23
            Layout.alignment: Qt.AlignVCenter

            source: root.entry && root.entry.icon
                ? Quickshell.iconPath(root.entry.icon, "application-x-executable")
                : Quickshell.iconPath("application-x-executable")

            sourceSize.width: 48
            sourceSize.height: 48
            fillMode: Image.PreserveAspectFit
            smooth: true
            asynchronous: true
        }

        // application name
        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            text: root.entry
                ? (root.entry.name || root.entry.id || "Unknown application")
                : "Unknown application"

            color: root.foregroundColor
            font.family: root.fontFamily
            font.pixelSize: 12
            font.weight: Font.Medium
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }

        // selected result indicator
        Text {
            text: root.selected ? "↵" : ""
            color: root.foregroundColor
            font.family: root.iconFontFamily
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // mouse interaction
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered()
        onClicked: root.activated()
    }
}