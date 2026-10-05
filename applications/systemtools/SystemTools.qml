import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible: true
 width: 900
 height: 600
 title: "WINUX11 System Tools"
 color: "#090b10"
 ColumnLayout {
  anchors.fill: parent
  anchors.margins: 18
  spacing: 12
  Label { text: "System Tools — " + toolMode; font.pixelSize: 30; color: "white" }
  RowLayout {
   Layout.fillWidth: true
   Button { text: "Refresh"; onClicked: output.text = systemTools.query(toolMode) }
  }
  TextArea { id: output; Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; color: "white"; text: systemTools.query(toolMode); wrapMode: TextEdit.Wrap }
 }
}