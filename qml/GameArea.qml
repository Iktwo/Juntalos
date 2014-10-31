import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 1.2
import "."

FocusScope {
    id: root

    property var activeColors: []

    property var values: []
    property var ownedByPlayer: []
    property var ownedByComputer: []

    property int columns: 5
    property int rows: 5

    property int currentPlayerColor: values[rightTopCorner]
    property int currentComputerColor: values[bottomLeftCorner]

    property int rightTopCorner: columns - 1
    property int bottomLeftCorner: (rows - 1) * columns

    property int colors: Math.min(6, Colors.colors.length)

    /// TODO: what if surrounded by enemy

    function getDifferentNumber(number, limit) {
        if (limit < 2) {
            console.warn("Should not call getDifferentNumber with limit less than 2")
            return number
        }

        var newNumber = Math.floor(Math.random() * limit)
        if (newNumber !== number)
            return newNumber
        else
            return getDifferentNumber(number, limit)
    }

    function reset() {
        console.time("FunctionReset")
        var array = []

        for (var i = 0; i < columns; i++) {
            for (var j = 0; j < rows; j++) {
                array.push(Math.floor(Math.random() * root.colors))
            }
        }

        /// If initial piece is the same color for player and computer reset
        if (array[rightTopCorner] === array[bottomLeftCorner]) {
            array[rightTopCorner] = getDifferentNumber(array[rightTopCorner], root.colors)
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
        console.timeEnd("FunctionReset")

        ownedByPlayer = groupForIndex(bottomLeftCorner)
    }

    /// TODO: Check only frontier
    function groupForIndex(index) {
        console.time("FunctionGroupForIndex")
        var result = [index]
        var toCheck = neighboursForIndex(index)

        while (toCheck.length > 0) {
            var value = toCheck.shift()
            if (result.indexOf(value) === -1) {
                result.push(value)
                var neighbours = neighboursForIndex(value)
                for (var i = 0; i < neighbours.length; i++) {
                    if (result.indexOf(neighbours[i]) === -1 && toCheck.indexOf(neighbours[i]) === -1)
                        toCheck.push(neighbours[i])
                }
            }
        }

        console.timeEnd("FunctionGroupForIndex")
        console.log("TOTAL:", result.length, "RESULTS:", result)

        return result
    }

    function neighboursForIndex(index) {
        console.count("neighboursForIndex")
        /// Check ← ↑ → ↓
        var result = []

        if (index % columns > 0 && values[index] === values[index - 1])
            result.push(index - 1)

        if (index % columns < columns - 1 && values[index] === values[index + 1])
            result.push(index + 1)

        if (index > columns - 1 &&  values[index] === values[index - columns])
            result.push(index - columns)

        if (index < (columns * rows) - columns &&  values[index] === values[index + columns])
            result.push(index + columns)

        return result
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
        playerTile: root.currentPlayerColor
        computerTile: root.currentComputerColor

        onTileClicked: {
            var values = root.values
            for (var i = 0; i < ownedByPlayer.length; i++) {
                values[ownedByPlayer[i]] = index
            }

            root.values = values

            ownedByPlayer = groupForIndex(bottomLeftCorner)

            console.log("Index", index, "Value", value)
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
                color: root.activeColors[root.values[index]]

                Text {
                    anchors.centerIn: parent
                    color: "WHITE"
                    text: index
                    font.pixelSize: 22
                    visible: textVisible
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        groupForIndex(index)
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
            horizontalOffset: 0
            verticalOffset: 0
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

    Row {
        width: parent.width

        Button {
            anchors.top: parent.top
            text: "Reset"
            onClicked: {
                reset()
            }
        }

        Button {
            anchors.top: parent.top
            text: "Show Index"
            onClicked: {
                textVisible = !textVisible
            }
        }

        Button {
            anchors.top: parent.top
            text: "Set Same"
            onClicked: {
                var xxx = values
                for (var i = 0; i < xxx.length; i++)
                    xxx[i] = 1

                values = xxx
            }
        }
    }

    property bool textVisible: false
}
