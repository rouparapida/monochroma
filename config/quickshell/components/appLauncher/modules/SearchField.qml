
import QtQuick
import qs.colors

Item {
    id: root

    property var currentTheme: CurrentColorscheme

    // public properties
    property alias text: input.text
    property color foregroundColor: currentTheme.color1
    property color placeholderColor: currentTheme.color13
    property string fontFamily: currentTheme.font
    property string iconFontFamily: currentTheme.nerdFont

    signal keyPressed(var event)

    // focus input and move cursor to the end
    function focusInput(): void {
        input.forceActiveFocus()
        input.cursorPosition = input.text.length
    }

    // search icon
    Text {
        id: searchIcon

        anchors {
            left: parent.left
            leftMargin: 8
            verticalCenter: parent.verticalCenter
        }

        text: ""
        color: root.foregroundColor
        font.family: root.iconFontFamily
        font.pixelSize: 17
    }

    // input area
    Item {
        id: inputArea

        anchors {
            left: searchIcon.right
            leftMargin: 12
            right: parent.right
            rightMargin: 8
            top: parent.top
            bottom: parent.bottom
        }

        clip: true

        // placeholder text
        Text {
            anchors.verticalCenter: parent.verticalCenter

            visible: input.text.length === 0
            text: "Search applications..."
            color: root.placeholderColor
            font.family: root.fontFamily
            font.pixelSize: 14
        }

        // text input
        TextInput {
            id: input

            anchors.fill: parent

            verticalAlignment: TextInput.AlignVCenter
            color: root.foregroundColor
            selectionColor: "#5f5f5f"
            selectedTextColor: "#ffffff"

            // custom cursor
            cursorDelegate: Rectangle {
                width: 1
                color: root.foregroundColor
            }

            font.family: root.fontFamily
            font.pixelSize: 14

            clip: true
            selectByMouse: true
            focus: false

            // forward keyboard events to the launcher
            Keys.priority: Keys.BeforeItem
            Keys.onPressed: function(event) {
                root.keyPressed(event)
            }
        }
    }
}
