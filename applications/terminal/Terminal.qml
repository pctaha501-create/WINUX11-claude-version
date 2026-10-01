import QtQuick
import QtQuick.Controls
ApplicationWindow {
    visible: true; width: 900; height: 600
    title: "WINUX11 Terminal"; color: "#090b10"
    TextArea {
        id: output
        anchors.fill: parent; anchors.margins: 10
        color: "#e8edf7"; background: Rectangle { color: "#0d1017" }
        font.family: "monospace"; wrapMode: TextArea.NoWrap
        readOnly: false; focus: true
        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier)) {
                terminal.interrupt(); event.accepted = true; return;
            }
            if (event.key === Qt.Key_Backspace) {
                terminal.write("\b"); event.accepted = true; return;
            }
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                terminal.write("\n"); event.accepted = true; return;
            }
            if (event.text && event.text.length > 0 && !(event.modifiers & Qt.ControlModifier)) {
                terminal.write(event.text); event.accepted = true;
            }
        }
        Component.onCompleted: {
            terminal.output.connect(function(text) { output.append(text.replace(/\n/g, "\n")); output.cursorPosition = output.length; })
            terminal.start()
        }
        Component.onDestruction: terminal.interrupt()
    }
}
