import QtQuick
import QtQuick.Layouts

// search field configuration
Item {
    id: root

    // public properties
    property alias text: input.text
    property color foregroundColor: "#f2f2f2"
    property color placeholderColor: "#929292"
    property string fontFamily: "Inter"
    property string iconFontFamily: "JetbrainsMono Nerd Font Propo"

    signal keyPressed(var event)

    // focus input and move cursor to the end
    function focusInput(): void {
        input.forceActiveFocus();
        input.cursorPosition = input.text.length;
    }

    // search field layout
    RowLayout {
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }
        spacing: 12

        // search icon
        Text {
            text: ""
            color: root.placeholderColor
            font.family: root.iconFontFamily
            font.pixelSize: 17
            Layout.alignment: Qt.AlignVCenter
        }

        // input area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
                    root.keyPressed(event);
                }
            }
        }
    }
}