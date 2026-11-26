import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property var currentTheme: CurrentColorscheme

    // public properties
    property var entry
    property bool selected: false
    property color foregroundColor: currentTheme.color1
    property color selectionColor: currentTheme.color11
    property string fontFamily: currentTheme.font
    property string iconFontFamily: currentTheme.nerdFont

    signal hovered()
    signal activated()

    // selection styling
    radius: 6
    color: selected ? selectionColor : "transparent"

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