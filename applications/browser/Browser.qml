import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
ApplicationWindow {
    visible: true; width: 1200; height: 800
    title: "WINUX11 Browser"; color: "#090b10"
    property string urlText: "https://www.qt.io"
    ColumnLayout {
        anchors.fill: parent; spacing: 0
        RowLayout {
            Layout.fillWidth: true
            TextField { Layout.fillWidth: true; text: urlText; onAccepted: page.url = text }
            Button { text: "↻"; onClicked: page.reload() }
        }
        WebEngineView { id: page; Layout.fillWidth: true; Layout.fillHeight: true; url: urlText }
    }
}
