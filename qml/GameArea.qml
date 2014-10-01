import QtQuick 2.0

FocusScope {
    id: root

    property var colors: ["#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#e67e22"]

    property var values: []

    property int columns: 5
    property int rows: 5

    function reset() {
        root.values = []

        for (var i = 0; i < columns; i++) {
            for (var j = 0; j < rows; j++) {
                root.values.push(Math.floor(Math.random() * 5))
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

        cellHeight: height / root.columns
        cellWidth: width / root.rows

        delegate: Rectangle {
            id: delegate

            height: GridView.view.height / root.columns
            width: GridView.view.width / root.rows
            color: root.colors[root.values[index]]

            Rectangle {
                anchors {
                    fill: parent
                    margins: 1
                }

                color: "#00000000"

                border {
                    color: Qt.lighter(root.colors[root.values[index]])
                    width: 2
                }
            }
        }
    }
}