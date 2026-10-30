
pragma Singleton
import QtQuick

QtObject {
    // Backgrounds
    readonly property color background: "#000000"
    readonly property color backgroundalt: "#14ffffff"
    readonly property color backgroundalt2: "#0a0a0a"
    readonly property color backgroundalt3: "#ffffff"
    readonly property color backgroundalt4: "#171717"
    readonly property color backgroundalt5: "#262626"
    readonly property color backgroundalt6: "#404040"

    // Text
    readonly property color text: "#ffffff"
    readonly property color textalt: "#33ffffff"
    readonly property color textalt2: "#88ffffff"
    readonly property color textalt3: "#000000"
    readonly property color textalt4: "#ccffffff"
    readonly property color textalt5: "#a3a3a3"
    readonly property color textalt6: "#737373"

    // Borders
    readonly property color border: "#1fffffff"
    readonly property color borderalt: "#33ffffff"
    readonly property color borderalt2: "#525252"
    readonly property color borderalt3: "#262626"

    // Interactive states
    readonly property color hover: "#14ffffff"
    readonly property color hoveralt: "#26ffffff"
    readonly property color selected: "#262626"
    readonly property color selectedalt: "#404040"
    readonly property color pressed: "#33ffffff"
    readonly property color disabled: "#4dffffff"

    // Icons
    readonly property color icon: "#ffffff"
    readonly property color iconalt: "#a3a3a3"
    readonly property color iconalt2: "#737373"
    readonly property color iconalt3: "#525252"

    // fonts
    readonly property string font: "Inter"
    readonly property string fontalt: "JetbrainsMono Nerd Font Propo"
}
