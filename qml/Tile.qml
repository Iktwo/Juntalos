import QtQuick 2.3

Rectangle {
    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }

        border {
            color: Qt.lighter(parent.color)
            width: 2
        }

        radius: parent.radius
        color: "#00000000"
    }
}
