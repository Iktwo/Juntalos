import QtQuick 2.3
import QtGraphicalEffects 1.0

FocusScope {
    id: root

    property var colors: [
        "#1abc9c", "#16a085", "#f1c40f", "#f39c12",
        "#2ecc71", "#27ae60", "#e67e22", "#d35400",
        "#3498db", "#2980b9", "#e74c3c", "#c0392b",
        "#9b59b6", "#8e44ad", "#34495e", "#2c3e50",
        "#95a5a6", "#7f8c8d"]

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
            var randomColor = root.colors[Math.floor((Math.random() * root.colors.length))]
            if (newColors.indexOf(randomColor) === -1) {
                console.log("RANDOM COLOR:", randomColor)
                newColors.push(randomColor)
            }
        }

        root.activeColors = newColors

        root.values = array
        gridView.model = root.columns * root.rows
    }

    onColumnsChanged: reset()
    onRowsChanged: reset()
    Component.onCompleted: reset()

    Flow {
        id: flowColors

        anchors {
            bottom: parent.bottom; bottomMargin: 8
            horizontalCenter: parent.horizontalCenter
        }

        spacing: 24

        width: 48 * 3 + (24 * 2)

        Repeater {
            model: 6
            Tile {
                height: 48
                width: 48
                tileColor: root.activeColors[index]

                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("TODO: change to this color")
                }
            }
        }
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
                tileColor: root.activeColors[root.values[index]]

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
                tileColor: root.activeColors[root.values[index]]
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
                tileColor: root.activeColors[root.values[index]]
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
