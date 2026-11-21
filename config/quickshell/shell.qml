//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Io
import qs.components.bar
import qs.components.osds
import qs.components.logout
import qs.components.appLauncher

ShellRoot {
    Bar {}

    VolumeOSD {}

    BrightnessOSD {}

    Logout {
        id: logout

        LogoutButton {
            command: "systemctl poweroff"
            keybind: Qt.Key_P
            text: "Poweroff"
            icon: "󰐥"
        }

        LogoutButton {
            command: "systemctl reboot"
            keybind: Qt.Key_R
            text: "Reboot"
            icon: "󰜉"
        }

        LogoutButton {
            command: "hyprlock"
            keybind: Qt.Key_L
            text: "Lockscreen"
            icon: "󰌾"
        }

        LogoutButton {
            command: "loginctl terminate-user $USER"
            keybind: Qt.Key_E
            text: "Logout"
            icon: "󰍃"
        }
    }

    IpcHandler {
        target: "logout"

        function open(): void {
            logout.active = true
        }

        function close(): void {
            logout.active = false
        }

        function toggle(): void {
            logout.active = !logout.active
        }
    }

    AppLauncher {
        id: appLauncher

        maxVisibleResults: 6
        launcherWidth: 620
    }
}
