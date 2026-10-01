import QtQuick
import QtQuick.Controls
ApplicationWindow {
    visible: true
    width: 900
    height: 600
    title: "WINUX11 Terminal"
    color: "#090b10"
    TextArea {
        id: output
        anchors.fill: parent
        anchors.margins: 10
        color: "#e8edf7"
        background: Rectangle { color: "#0d1017" }
        font.family: "monospace"
        wrapMode: TextArea.NoWrap
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
                terminal.interrupt(); event.accepted = true
            }
        }
        Component.onCompleted: terminal.output.connect(function(text) { output.append(text) })
        Component.onDestruction: terminal.interrupt()
    }
}
