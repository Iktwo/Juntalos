import QtQuick 2.3
import QtGraphicalEffects 1.0
import "."

FocusScope {
    id: root

    property var activeColors: []

    property var values: []
    property var ownedByPlayer: []
    property var ownedByComputer: []

    property int columns: 5
    property int rows: 5

    function reset() {
        var array = []

        for (var i = 0; i < columns; i++) {
            for (var j = 0; j < rows; j++) {
                array.push(Math.floor(Math.random() * 6))
            }
        }

        /// If initial piece is the same color for player and computer reset
        if (array[columns - 1] === array[(rows - 1) * columns]) {
            root.reset()
            return
        }

        var newColors = []
        while (newColors.length < 6) {
            var randomColor = Colors.colors[Math.floor((Math.random() * Colors.colors.length))]
            if (newColors.indexOf(randomColor) === -1)
                newColors.push(randomColor)
        }

        root.activeColors = newColors

        root.values = array
        gridView.model = root.columns * root.rows
    }

    onColumnsChanged: reset()
    onRowsChanged: reset()
    Component.onCompleted: reset()

    ColorButtons {
        id: flowColors

        anchors {
            bottom: parent.bottom; bottomMargin: 8
            horizontalCenter: parent.horizontalCenter
        }

        colors: root.activeColors
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: flowColors.top
            margins: 8
        }

        GridView {
            id: gridView

            anchors.centerIn: parent

            height: Math.min(parent.height, parent.width)
            width: Math.min(parent.height, parent.width)

            cellHeight: height / root.rows
            cellWidth: width / root.columns
            interactive: false

            delegate: Tile {
                height: GridView.view.height / root.rows
                width: GridView.view.width / root.columns
                color: root.activeColors[root.values[index]]

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var array = root.ownedByPlayer
                        array.push(index)
                        root.ownedByPlayer = array
                    }
                }
            }
        }

        GridView {
            id: gridViewInnerShadow

            anchors.centerIn: parent

            height: Math.min(parent.height, parent.width)
            width: Math.min(parent.height, parent.width)

            cellHeight: height / root.rows
            cellWidth: width / root.columns
            interactive: false

            model: gridView.model
            visible: false

            delegate: Tile {
                height: GridView.view.height / root.rows
                width: GridView.view.width / root.columns
                color: root.activeColors[root.values[index]]
                visible: ownedByComputer.indexOf(index) !== -1

                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    opacity: 0.05
                }
            }
        }

        InnerShadow {
            anchors.fill: gridViewInnerShadow
            horizontalOffset: 0//6
            verticalOffset: 0//6
            radius: 18.0
            samples: 16
            color: "#A0000000"
            source: gridViewInnerShadow
            fast: true
            spread: 0.55
        }

        GridView {
            id: gridViewDropShadow

            anchors.centerIn: parent

            height: Math.min(parent.height, parent.width)
            width: Math.min(parent.height, parent.width)

            cellHeight: height / root.rows
            cellWidth: width / root.columns
            interactive: false

            model: gridView.model

            delegate: Tile {
                height: GridView.view.height / root.rows
                width: GridView.view.width / root.columns
                color: root.activeColors[root.values[index]]
                visible: ownedByPlayer.indexOf(index) !== -1
            }
        }

        DropShadow {
            anchors.fill: gridViewDropShadow
            horizontalOffset: 0
            verticalOffset: 0
            radius: 18
            samples: 16
            color: "#A0000000"
            source: gridViewDropShadow
            spread: 0.55
            fast: true
        }
    }
}
