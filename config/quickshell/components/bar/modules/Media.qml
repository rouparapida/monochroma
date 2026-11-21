import QtQuick
import Quickshell.Services.Mpris
import qs.colors

Item {
    id: root

    // configuration
    property var currentTheme: CurrentColorscheme
    property int maxTextWidth: 150

    // selects the most relevant media playing
    readonly property var activePlayer: {
        const players = Mpris.players.values

        // prefer the currently playing player
        for (const player of players) {
            if (
                player.playbackState === MprisPlaybackState.Playing
                && String(player.trackTitle || "").trim().length > 0
            ) {
                return player
            }
        }

        // keep showing the track when paused
        for (const player of players) {
            if (
                player.playbackState === MprisPlaybackState.Paused
                && String(player.trackTitle || "").trim().length > 0
            ) {
                return player
            }
        }

        return null
    }

    // formats the information
    readonly property string trackInfo: {
        if (!activePlayer)
            return ""
    
        return String(activePlayer.trackTitle || "").trim()
    }

    // text displayed when no media player is available
    readonly property string displayText:
        activePlayer ? trackInfo : "No media found"

    implicitWidth: musicIcon.implicitWidth
        + contentRow.spacing
        + Math.min(trackLabel.implicitWidth, maxTextWidth)

    implicitHeight: Math.max(
        musicIcon.implicitHeight,
        trackLabel.implicitHeight
    )

    // main content layout
    Row {
        id: contentRow

        anchors.centerIn: parent
        spacing: 7

        // icon
        Text {
            id: musicIcon

            anchors.verticalCenter: parent.verticalCenter

            text: ""

            font.family: root.currentTheme.nerdFont
            font.pixelSize: 12

            color: root.activePlayer
                ? root.currentTheme.color1
                : root.currentTheme.color8
        }

        // track information
        Text {
            id: trackLabel

            anchors.verticalCenter: parent.verticalCenter

            // prevent long track titles
            width: Math.min(implicitWidth, root.maxTextWidth)

            text: root.displayText

            color: root.activePlayer
                ? root.currentTheme.color1
                : root.currentTheme.color8

            font.family: root.currentTheme.font
            font.pixelSize: 11
            font.weight: Font.Medium

            elide: Text.ElideRight
            maximumLineCount: 1
        }

        Behavior on width {
           NumberAnimation {
               duration: 200
               easing.type: Easing.OutCubic
           }
        }
    }
}