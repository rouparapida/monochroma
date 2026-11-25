
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import qs.colors
import qs.components.appLauncher.modules
import "logic/AppSearch.js" as AppSearch

PanelWindow {
    id: root

    // public configuration
    property int maxVisibleResults: 6
    property int maxResults: 80
    property int resultRowHeight: 42
    property int launcherWidth: 600
    property int cardRadius: 0
    property var extraEntries: []
    property var currentTheme: CurrentColorscheme

    // module colors
    property color surfaceColor: currentTheme.color0
    property color textColor: currentTheme.color1
    property color secondaryTextColor: currentTheme.color8
    property color borderColor: currentTheme.color13
    property color selectionColor: currentTheme.color2
    property color overlayColor: currentTheme.color14

    // module fonts
    property string textFont: "Inter"
    property string iconFont: "JetbrainsMono Nerd Font Propo"

    // launcher state
    property var results: []
    property int selectedIndex: 0
    property bool closing: false

    // calculate visible results height
    readonly property int visibleResultCount: Math.min(results.length, Math.max(1, maxVisibleResults))
    readonly property int resultsViewportHeight: visibleResultCount > 0
        ? visibleResultCount * resultRowHeight + (visibleResultCount - 1) * resultsView.spacing
        : 0

    // panel anchors
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    visible: false
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    // refresh search results
    function refreshResults(): void {
        const entries = DesktopEntries.applications.values.concat(extraEntries)
        results = AppSearch.search(entries, searchField.text, maxResults)
        selectedIndex = 0

        Qt.callLater(function() {
            resultsView.positionViewAtBeginning()
        })
    }

    // open launcher
    function open(): void {
        hideAnimation.stop()
        showAnimation.stop()
        closing = false

        searchField.text = ""
        refreshResults()
        visible = true

        backdrop.opacity = 0
        launcherCard.opacity = 0
        launcherCard.scale = 0.985

        Qt.callLater(function() {
            showAnimation.start()
            searchField.focusInput()
        })
    }

    // close launcher
    function close(): void {
        if (!visible || closing)
            return

        closing = true
        showAnimation.stop()
        hideAnimation.start()
    }

    // toggle launcher visibility
    function toggle(): void {
        if (visible && !closing)
            close()
        else
            open()
    }

    // navigate search results
    function moveSelection(direction: int): void {
        if (results.length === 0)
            return

        selectedIndex = (selectedIndex + direction + results.length) % results.length

        Qt.callLater(function() {
            resultsView.positionViewAtIndex(selectedIndex, ListView.Contain)
        })
    }

    // launch selected application
    function launchSelected(): void {
        if (selectedIndex < 0 || selectedIndex >= results.length)
            return

        const entry = results[selectedIndex].entry
        if (!entry)
            return

        if (typeof entry.execute === "function") {
            entry.execute()
        } else if (entry.command && entry.command.length > 0) {
            Quickshell.execDetached({
                command: entry.command,
                workingDirectory: entry.workingDirectory || undefined
            })
        } else {
            return
        }

        close()
    }

    // keyboard shortcuts
    function handleKey(event): void {
        switch (event.key) {
        case Qt.Key_Down:
            moveSelection(1)
            event.accepted = true
            break
        case Qt.Key_Up:
            moveSelection(-1)
            event.accepted = true
            break
        case Qt.Key_Return:
        case Qt.Key_Enter:
            launchSelected()
            event.accepted = true
            break
        case Qt.Key_Escape:
            close()
            event.accepted = true
            break
        default:
            break
        }
    }

    // update results when applications change
    Connections {
        target: DesktopEntries

        function onApplicationsChanged(): void {
            root.refreshResults()
        }
    }

    // launcher ipc
    IpcHandler {
        target: "appLauncher"

        function toggle(): void { root.toggle() }
        function open(): void { root.open() }
        function close(): void { root.close() }
    }

    // background overlay
    Rectangle {
        id: backdrop
        anchors.fill: parent
        color: root.overlayColor
        opacity: 0

        // close launcher when clicking outside
        MouseArea {
            anchors.fill: parent
            onClicked: root.close()
        }
    }

    // centered launcher container
    Item {
        id: centeredContainer
        anchors.centerIn: parent
        width: Math.min(root.launcherWidth, parent.width - 48)
        height: launcherCard.height

        // launcher panel
        Rectangle {
            id: launcherCard

            width: parent.width
            height: contentColumn.implicitHeight + 28
            radius: root.cardRadius
            color: root.surfaceColor

            opacity: 0
            scale: 0.985
            clip: true

            // animate panel resizing
            Behavior on height {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }

            // prevent clicks inside panel from closing it
            MouseArea {
                anchors.fill: parent
                onClicked: mouse.accepted = true
            }

            // launcher content layout
            Column {
                id: contentColumn

                anchors {
                    fill: parent
                    margins: 14
                }

                spacing: 0

                // search field
                SearchField {
                    id: searchField

                    width: parent.width
                    height: 26

                    foregroundColor: root.textColor
                    placeholderColor: root.secondaryTextColor
                    fontFamily: root.textFont
                    iconFontFamily: root.iconFont

                    onTextChanged: root.refreshResults()
                    onKeyPressed: function(event) {
                        root.handleKey(event)
                    }
                }

                // search results section
                Column {
                    id: resultsSection

                    width: parent.width
                    visible: searchField.text.trim().length > 0
                    spacing: 8

                    // results divider
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: root.borderColor
                    }

                    // results list
                    ListView {
                        id: resultsView

                        width: parent.width
                        height: root.resultsViewportHeight
                        clip: true
                        spacing: 2
                        model: root.results
                        currentIndex: root.selectedIndex
                        boundsBehavior: Flickable.StopAtBounds
                        reuseItems: true

                        // result item
                        delegate: ResultRow {
                            required property var modelData
                            required property int index

                            width: resultsView.width
                            height: root.resultRowHeight

                            entry: modelData.entry
                            selected: index === root.selectedIndex

                            foregroundColor: root.textColor
                            selectionColor: root.selectionColor
                            fontFamily: root.textFont
                            iconFontFamily: root.iconFont

                            // update selection on hover
                            onHovered: root.selectedIndex = index

                            // launch clicked result
                            onActivated: {
                                root.selectedIndex = index
                                root.launchSelected()
                            }
                        }
                    }

                    // empty search state
                    Item {
                        width: parent.width
                        height: 42
                        visible: root.results.length === 0

                        // empty state message
                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "No applications found"
                                color: root.textColor
                                font.family: root.textFont
                                font.pixelSize: 12
                                font.weight: Font.Medium
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "Try another search term"
                                color: root.secondaryTextColor
                                font.family: root.textFont
                                font.pixelSize: 10
                            }
                        }
                    }
                }
            }
        }

        // independent card border
        Rectangle {
            id: launcherBorder

            anchors.fill: launcherCard

            color: "transparent"
            radius: root.cardRadius

            border.width: 1
            border.color: root.borderColor

            opacity: launcherCard.opacity
            scale: launcherCard.scale

            z: 1
        }
    }

    // opening animation
    ParallelAnimation {
        id: showAnimation

        NumberAnimation {
            target: backdrop
            property: "opacity"
            from: 0
            to: 1
            duration: 130
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: launcherCard
            property: "opacity"
            from: 0
            to: 1
            duration: 150
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: launcherCard
            property: "scale"
            from: 0.985
            to: 1
            duration: 170
            easing.type: Easing.OutCubic
        }
    }

    // closing animation
    ParallelAnimation {
        id: hideAnimation

        NumberAnimation {
            target: backdrop
            property: "opacity"
            to: 0
            duration: 110
            easing.type: Easing.InCubic
        }

        NumberAnimation {
            target: launcherCard
            property: "opacity"
            to: 0
            duration: 110
            easing.type: Easing.InCubic
        }

        NumberAnimation {
            target: launcherCard
            property: "scale"
            to: 0.985
            duration: 110
            easing.type: Easing.InCubic
        }

        // hide panel after animation
        onFinished: {
            root.visible = false
            root.closing = false
        }
    }
}
