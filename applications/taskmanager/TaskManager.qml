import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
    visible: true
    width: 900; height: 650
    title: "WINUX11 Task Manager"
    color: "#0a0d12"
    property var rows: processService.processes()
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 18; spacing: 12
        RowLayout {
            Layout.fillWidth: true
            Label { text: "Processes"; font.pixelSize: 30; color: "white" }
            Item { Layout.fillWidth: true }
            Button { text: "Refresh"; onClicked: rows = processService.processes() }
        }
        ListView {
            id: list
            Layout.fillWidth: true; Layout.fillHeight: true
            model: rows
            delegate: Rectangle {
                width: list.width; height: 42; color: index % 2 ? "#10141c" : "#0d1118"
                RowLayout {
                    anchors.fill: parent; anchors.margins: 8
                    Label { Layout.preferredWidth: 90; text: modelData.pid; color: "#cdd5e5" }
                    Label { Layout.fillWidth: true; text: modelData.name; color: "white"; elide: Text.ElideRight }
                    Label { Layout.preferredWidth: 120; text: modelData.state; color: "#9ba7ba" }
                    Button { text: "End"; onClicked: { processService.terminateProcess(modelData.pid); rows = processService.processes() } }
                }
            }
        }
    }
}
