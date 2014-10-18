import QtQuick 2.3
import QtGraphicalEffects 1.0

FocusScope {
    id: root

    property var colors: ["#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#e67e22", "#e74c3c"]

    property var values: []
    property var ownedByPlayer: [2, 4, 5, 6, 7, 8]
    property var ownedByComputer: [9, 10, 11, 12]

    property int columns: 5
    property int rows: 5

    function reset() {
        root.values = []

        for (var i = 0; i < columns; i++) {
            for (var j = 0; j < rows; j++) {
                root.values.push(Math.floor(Math.random() * 6))
            }
        }

        gridView.model = root.columns * root.rows
    }

    onColumnsChanged: reset()
    onRowsChanged: reset()
    Component.onCompleted: reset()

    GridView {
        id: gridView

        anchors.centerIn: parent

        height: Math.min(root.height, root.width)
        width: Math.min(root.height, root.width)

        cellHeight: height / root.rows
        cellWidth: width / root.columns
        interactive: false

        delegate: Tile {
            height: GridView.view.height / root.rows
            width: GridView.view.width / root.columns
            tileColor: root.colors[root.values[index]]
        }
    }

    GridView {
        id: gridViewInnerShadow

        anchors.centerIn: parent

        height: Math.min(root.height, root.width)
        width: Math.min(root.height, root.width)

        cellHeight: height / root.rows
        cellWidth: width / root.columns
        interactive: false

        model: gridView.model
        visible: false

        delegate: Tile {
            height: GridView.view.height / root.rows
            width: GridView.view.width / root.columns
            tileColor: root.colors[root.values[index]]
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
        visible: shadowsVisible
    }


    GridView {
        id: gridViewDropShadow

        anchors.centerIn: parent

        height: Math.min(root.height, root.width)
        width: Math.min(root.height, root.width)

        cellHeight: height / root.rows
        cellWidth: width / root.columns
        interactive: false

        model: gridView.model
        visible: false

        delegate: Tile {
            height: GridView.view.height / root.rows
            width: GridView.view.width / root.columns
            tileColor: root.colors[root.values[index]]
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

        visible: shadowsVisible
    }

    property bool shadowsVisible: true
    MouseArea {
        anchors.fill: parent
        onClicked: shadowsVisible ^= 1
    }
}
