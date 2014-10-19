import QtQuick 2.3

Flow {
    id: root

    property var colors
    signal tileClicked(int index, string value)

    spacing: 16
    width: 48 * 3 + (24 * 2)

    Repeater {
        model: 6
        Tile {
            height: 48
            width: 48
            color: root.colors !== undefined && root.colors.length > index ? root.colors[index] : "white"

            MouseArea {
                anchors.fill: parent
                onClicked: root.tileClicked(index, root.colors !== undefined && root.colors.length > index ? root.colors[index] : "white")
            }
        }
    }
}
