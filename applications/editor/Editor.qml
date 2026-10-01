import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
 visible: true
 width: 1000
 height: 700
 title: "WINUX11 Text Editor"
 color: "#090b10"
 ColumnLayout {
  anchors.fill: parent
  anchors.margins: 12
  spacing: 10
  RowLayout {
   Layout.fillWidth: true
   TextField { id: path; Layout.fillWidth: true; placeholderText: "/path/to/file" }
   Button { text: "Open"; onClicked: { editor.text = editorService.read(path.text); status.text = "Opened" } }
   Button { text: "Save"; onClicked: { status.text = editorService.write(path.text, editor.text) ? "Saved" : "Save failed" } }
  }
  TextArea { id: editor; Layout.fillWidth: true; Layout.fillHeight: true; color: "#e8edf7"; font.family: "monospace"; wrapMode: TextEdit.Wrap }
  Label { id: status; color: "#aeb8c9"; text: "Ready" }
 }
}