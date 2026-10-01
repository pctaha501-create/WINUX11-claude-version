import QtQuick
import QtQuick.Controls
ApplicationWindow {
    visible: true; width: 900; height: 650
    title: "WINUX11 Settings"; color: "#0a0d12"
    Column {
        anchors.fill: parent; anchors.margins: 32; spacing: 18
        Label { text: "Settings"; font.pixelSize: 34; color: "white" }
        Label { text: "System information"; font.pixelSize: 20; color: "#b9c0cf" }
        TextArea { id: details; width: parent.width; height: 260; readOnly: true; color: "#e8edf7"; background: Rectangle { color: "#11151d"; radius: 14 } }
        Button { text: "Refresh"; onClicked: details.text = JSON.stringify(systemInfo.snapshot(), null, 2) }
    }
    Component.onCompleted: details.text = JSON.stringify(systemInfo.snapshot(), null, 2)
}
