import QtQuick
import QtQuick.Controls
ApplicationWindow {
    visible: true; width: 900; height: 650
    title: "WINUX11 Task Manager"; color: "#0a0d12"
    Column {
        anchors.fill: parent; anchors.margins: 18; spacing: 12
        Label { text: "Processes"; font.pixelSize: 30; color: "white" }
        ListView {
            width: parent.width; height: parent.height - 60
            model: procDir.entryList(["[0-9]*"])
            delegate: Label { text: modelData; color: "#dce2ef"; padding: 5 }
        }
    }
}
