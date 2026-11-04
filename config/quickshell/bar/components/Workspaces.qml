
import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root

    // Colors
    property color focusedBg: "#ffffff"
    property color unfocusedBg: "#888888"
    property color emptyBg: "#333333"

    // Dimensions
    property int indicatorSize: 8
    property int activeWidth: 28
    property int indicatorHeight: 10
    property int indicatorSpacing: 5

    // Find the highest workspace ID
    readonly property int dynamicMax: {
        let max = 6;
        const workspaces = Hyprland.workspaces.values;

        for (let i = 0; i < workspaces.length; i++) {
            if (workspaces[i].id > max)
                max = workspaces[i].id;
        }

        if (Hyprland.focusedWorkspace
                && Hyprland.focusedWorkspace.id > max) {
            max = Hyprland.focusedWorkspace.id;
        }

        return max;
    }

    spacing: indicatorSpacing

    Repeater {
        model: root.dynamicMax

        delegate: Rectangle {
            id: indicator

            required property int index

            readonly property int workspaceId: index + 1

            readonly property var workspace: {
                const workspaces = Hyprland.workspaces.values;

                return workspaces.find(
                    ws => ws.id === workspaceId
                ) || null;
            }

            readonly property bool isFocused:
                Hyprland.focusedWorkspace !== null
                && Hyprland.focusedWorkspace !== undefined
                && Hyprland.focusedWorkspace.id === workspaceId

            readonly property bool isOccupied: workspace !== null

            // Active workspace is a pill; inactive ones are circles
            width: isFocused ? root.activeWidth : root.indicatorSize
            height: isFocused ? root.indicatorHeight : root.indicatorSize

            radius: height / 2

            color: isFocused
                   ? root.focusedBg
                   : isOccupied
                     ? root.unfocusedBg
                     : root.emptyBg

            // Keep indicators vertically aligned
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined

            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }

            MouseArea {
                anchors.fill: parent

                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    Hyprland.dispatch(
                        "workspace " + indicator.workspaceId
                    );
                }
            }
        }
    }
}
