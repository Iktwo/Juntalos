import QtQuick 2.3

Item {
    property color tileColor

    height: 100
    width: 100

    Rectangle {
        anchors.fill: parent
        color: tileColor
    }

    Rectangle {
        anchors {
            fill: parent
            margins: 1
        }

        border {
            color: Qt.lighter(tileColor)
            width: 2
        }

        color: "#00000000"
    }
}
