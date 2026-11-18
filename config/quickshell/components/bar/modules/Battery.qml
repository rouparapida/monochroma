import QtQuick
import Quickshell.Services.UPower
import qs.colors

Row {
    id: root

    property var currentTheme: CurrentColorscheme

    // main battery device and charging state
    readonly property var battery: UPower.displayDevice
    readonly property bool pluggedIn: !UPower.onBattery

    // returns the battery percentage as an int
    readonly property int batteryPercentage: {
        if (!battery || !battery.ready)
            return -1

        const raw = Number(battery.percentage)

        if (!Number.isFinite(raw))
            return -1

        // normalize values between 0 and 1 into percentages
        return Math.round(raw <= 1 ? raw * 100 : raw)
    }

    spacing: 4

    // icon
    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: root.pluggedIn ? "" : ""

        font.family: root.currentTheme.nerdFont
        font.pixelSize: root.pluggedIn ? 12 : 12

        color: root.currentTheme.color1
    }

    // percentage label
    Text {
        anchors.verticalCenter: parent.verticalCenter

        text: root.batteryPercentage >= 0
              ? root.batteryPercentage + "%"
              : "--%"

        font.family: root.currentTheme.font
        font.pixelSize: 11
        font.weight: Font.Medium

        color: root.currentTheme.color1
    }
}