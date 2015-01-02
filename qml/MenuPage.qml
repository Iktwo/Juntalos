import QtQuick 2.4
import QtQuick.Controls 1.3
import com.iktwo.components 1.0

Page {
    width: 100
    height: 62

    Column {
        anchors.centerIn: parent
        spacing: 32 * ScreenValues.dp

        Button {
            text: qsTr("60 seconds")
        }

        Button {
            text: qsTr("player vs computer")
        }

        Button {
            text: qsTr("2 players")
        }
    }
}

