
import Quickshell
import QtQuick
import QtQuick.VectorImage

Rectangle {
    id: root

    implicitHeight: 18
    implicitWidth: 18

    color: "transparent"

    VectorImage {
        id: icon

        anchors.centerIn: parent

        source: Qt.resolvedUrl("../../../assets/icons/power.svg")

        width: 14
        height: 14

        fillMode: VectorImage.PreserveAspectFit
        preferredRendererType: VectorImage.CurveRenderer
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            Quickshell.execDetached(["systemctl", "poweroff"])
        }
    }
}
