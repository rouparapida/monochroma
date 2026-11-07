import QtQuick
import Quickshell
import Quickshell.Hyprland

// workspaces module configuration
Row {
    id: root

    property color focusedBg: "#ffffff"
    property color unfocusedBg: "#888888"
    property color emptyBg: "#333333"

    property int indicatorSize: 8
    property int indicatorHeight: 8
    property int indicatorSpacing: 5
    property int activeWidth: 28

    // find highest workspace id
    readonly property int dynamicMax: {
        let max = 10;
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

    // workspace module
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

            anchors.verticalCenter: parent ? parent.verticalCenter : undefined

            // active workspace is a pill, inactives are circles
            width: isFocused ? root.activeWidth : root.indicatorSize
            height: isFocused ? root.indicatorHeight : root.indicatorSize

            radius: height / 2

            // active workspaces are white, the ones that have windows in are grey, and the inactive ones are darker grey
            color: isFocused
                   ? root.focusedBg
                   : isOccupied
                     ? root.unfocusedBg
                     : root.emptyBg

            Behavior on width {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}