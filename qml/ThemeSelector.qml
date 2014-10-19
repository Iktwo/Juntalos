import QtQuick 2.3
import "."

Item {
    id: root

    property var activeColors: []

    Flow {
        id: colors

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        spacing: 16
        width: parent.width - 16

        Repeater {
            model: Colors.colors.length
            Rectangle {
                height: 48
                width: 48

                Tile {
                    id: tile

                    height: parent.height
                    width: parent.width
                    antialiasing: true

                    Behavior on radius { NumberAnimation { easing.type: "InOutCubic" } }

                    color: Colors.colors[index]

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.activeColors.length < 6 && root.activeColors.indexOf(Colors.colors[index]) === -1) {
                                console.log(root.activeColors)
                                var colors = root.activeColors
                                colors.push(Colors.colors[index])
                                root.activeColors = colors
                                tile.radius = tile.width / 2
                                /// TODO: init animation
                            }
                        }
                    }
                }
            }
        }
    }

    ColorButtons {
        id: flowColors

        anchors {
            bottom: parent.bottom; bottomMargin: 8
            horizontalCenter: parent.horizontalCenter
        }

        colors: root.activeColors
        onTileClicked: {
            console.log("TILE:", index, "COLOR:", value)
        }
    }
}
