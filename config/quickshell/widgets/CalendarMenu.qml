
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    // Visibility
    property bool shown: false
    property bool windowVisible: false

    // Theme
    property color backgroundColor: "#000000"
    property color borderColor: "transparent"
    property color textColor: "#FFFFFF"
    property color mutedColor: "#888888"
    property color accentColor: "#FFFFFF"
    property color accentTextColor: "#000000"
    property color inactiveDayColor: "#666666"
    property color hoverColor: "#20FFFFFF"

    property string textFont: "Inter"

    // Calendar data
    property var monthNames: [
        "January", "February", "March",
        "April", "May", "June", "July",
        "August", "September", "October",
        "November", "December"
    ]

    property var weekdayLabels: [
        "MON", "TUE", "WED", "THU",
        "FRI", "SAT", "SUN"
    ]

    property var weekdayNames: [
        "Sunday", "Monday", "Tuesday",
        "Wednesday", "Thursday",
        "Friday", "Saturday"
    ]

    readonly property int todayDay: clock.date.getDate()
    readonly property int todayMonth: clock.date.getMonth()
    readonly property int todayYear: clock.date.getFullYear()

    readonly property int firstWeekday:
        (new Date(
            todayYear,
            todayMonth,
            1
        ).getDay() + 6) % 7

    readonly property int daysInMonth:
        new Date(
            todayYear,
            todayMonth + 1,
            0
        ).getDate()

    // Clock
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // IPC controls
    function setOpen(value) {
        if (value)
            windowVisible = true

        shown = value
    }

    function toggle() {
        setOpen(!shown)
    }

    IpcHandler {
        target: "calendarSidebar"

        function toggle(): void {
            root.toggle()
        }

        function open(): void {
            root.setOpen(true)
        }

        function close(): void {
            root.setOpen(false)
        }
    }

    // Sidebar window
    PanelWindow {
        id: panel

        anchors {
            left: true
            top: true
            bottom: true
        }

        implicitWidth: 340

        color: "transparent"
        visible: root.windowVisible

        margins {
            left: 0
            top: 0
            bottom: 0
        }

        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Ignore
        focusable: false

        // Sliding content
        Item {
            id: panelContent

            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: panel.width

            x: root.shown ? 0 : -width

            Behavior on x {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic

                    onFinished: {
                        if (!root.shown)
                            root.windowVisible = false
                    }
                }
            }

            // Background
            Rectangle {
                anchors.fill: parent

                color: root.backgroundColor

                border {
                    width: 1
                    color: root.borderColor
                }
            }

            // Main content
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24

                spacing: 18

                // Header
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "CALENDAR"

                        color: root.mutedColor

                        font {
                            family: root.textFont
                            pixelSize: 10
                            bold: true
                            letterSpacing: 2
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "HH:mm")

                        color: root.textColor

                        font {
                            family: root.textFont
                            pixelSize: 12
                            bold: true
                        }
                    }
                }

                // Current date
                RowLayout {
                    Layout.fillWidth: true

                    spacing: 14

                    Rectangle {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60

                        radius: 15
                        color: root.accentColor

                        Text {
                            anchors.centerIn: parent

                            text: Qt.formatDateTime(clock.date, "dd")

                            color: root.accentTextColor

                            font {
                                family: root.textFont
                                pixelSize: 29
                                bold: true
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true

                        spacing: 4

                        Text {
                            text: root.weekdayNames[
                                clock.date.getDay()
                            ].toUpperCase()

                            color: root.textColor

                            font {
                                family: root.textFont
                                pixelSize: 13
                                bold: true
                            }
                        }

                        Text {
                            text: root.monthNames[todayMonth]
                                + " " + todayYear

                            color: root.mutedColor

                            font {
                                family: root.textFont
                                pixelSize: 11
                            }
                        }
                    }
                }

                // Divider
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1

                    color: root.borderColor
                }

                // Current month
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: root.monthNames[todayMonth].toUpperCase()
                            + " " + todayYear

                        color: root.textColor

                        font {
                            family: root.textFont
                            pixelSize: 16
                            bold: true
                        }
                    }
                }

                // Weekday labels
                RowLayout {
                    Layout.fillWidth: true

                    spacing: 4

                    Repeater {
                        model: root.weekdayLabels

                        delegate: Text {
                            Layout.fillWidth: true

                            text: modelData
                            color: root.mutedColor

                            horizontalAlignment: Text.AlignHCenter

                            font {
                                family: root.textFont
                                pixelSize: 9
                                bold: true
                            }
                        }
                    }
                }

                // Calendar grid
                GridLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 228

                    columns: 7
                    rowSpacing: 6
                    columnSpacing: 4

                    Repeater {
                        model: 42

                        delegate: Rectangle {
                            id: dayCell

                            required property int index

                            Layout.fillWidth: true
                            Layout.preferredHeight: 32

                            property int dayNumber:
                                index - root.firstWeekday + 1

                            property bool inMonth:
                                dayNumber >= 1
                                && dayNumber <= root.daysInMonth

                            property bool isToday:
                                inMonth
                                && dayNumber === root.todayDay

                            radius: 9

                            color: isToday
                                ? root.accentColor
                                : "transparent"

                            Text {
                                anchors.fill: parent

                                text: dayCell.inMonth
                                    ? dayCell.dayNumber
                                    : ""

                                color: dayCell.isToday
                                    ? root.accentTextColor
                                    : root.inactiveDayColor

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                font {
                                    family: root.textFont
                                    pixelSize: 11
                                    bold: dayCell.isToday
                                }
                            }
                        }
                    }
                }

                // Flexible space for future modules
                Item {
                    Layout.fillHeight: true
                }
            }
        }
    }
}
