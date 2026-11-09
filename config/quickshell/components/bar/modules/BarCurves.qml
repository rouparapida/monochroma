
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property int radius: 16
    property color color: "#000000"

    implicitHeight: radius
    height: radius

    // bottom left curve
    Shape {
        id: leftCurve

        anchors.left: parent.left
        anchors.top: parent.top
        width: root.radius
        height: root.radius

        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"

            startX: root.radius
            startY: 0

            PathLine {
                x: 0
                y: 0
            }

            PathLine {
                x: 0
                y: root.radius
            }

            PathArc {
                x: root.radius
                y: 0
                radiusX: root.radius
                radiusY: root.radius
                direction: PathArc.CounterClockwise
            }
        }
    }

    // bottom right curve
    Shape {
        id: rightCurve

        anchors.right: parent.right
        anchors.top: parent.top
        width: root.radius
        height: root.radius

        preferredRendererType: Shape.CurveRenderer

        transform: Scale {
            xScale: -1
            yScale: 1
            origin.x: root.radius / 2
            origin.y: 0
        }

        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"

            startX: root.radius
            startY: 0

            PathLine {
                x: 0
                y: 0
            }

            PathLine {
                x: 0
                y: root.radius
            }

            PathArc {
                x: root.radius
                y: 0
                radiusX: root.radius
                radiusY: root.radius
                direction: PathArc.CounterClockwise
            }
        }
    }
}
