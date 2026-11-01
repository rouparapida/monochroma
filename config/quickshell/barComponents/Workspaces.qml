import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root

    property color focusedBg: "#ffffff"
    property color focusedText: "#000000"
    property color unfocusedText: "#ccffffff"
    property string textFont: "Inter"

    // find max workspace id
    readonly property int dynamicMax: {
        let max = 6; // max workspace visible by default
        let workspaces = Hyprland.workspaces.values;

        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id > max)
                max = workspaces[i].id;
        }

        if (Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id > max)
            max = Hyprland.focusedWorkspace.id;

        return max;
    }

    spacing: 3

    Repeater {
        model: root.dynamicMax
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            required property int index
            property int workspaceId: index + 1

            readonly property var hyprlandWorkspaces: {
                let found = Hyprland.workspaces.values.find((ws) => {
                    return ws.id === workspaceId;
                });

                return found ? found : {
                    "id": workspaceId,
                    "focused": false
                };
            }

            implicitWidth: hyprlandWorkspaces.focused ? 38 : 12
            implicitHeight: 16
            radius: height / 2

            color: hyprlandWorkspaces.focused ? root.focusedBg : "transparent"
            visible: hyprlandWorkspaces.id > 0

            Text {
                anchors.centerIn: parent
                text: hyprlandWorkspaces.id
                color: hyprlandWorkspaces.focused ? root.focusedText : root.unfocusedText
                font.pixelSize: 12
                font.bold: hyprlandWorkspaces.focused ? true : false
                font.family: root.textFont
            }

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}