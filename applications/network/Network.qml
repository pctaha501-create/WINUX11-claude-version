import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible: true
 width: 820
 height: 520
 title: "WINUX11 Network"
 color: "#090b10"
 ColumnLayout {
  anchors.fill: parent
  anchors.margins: 22
  spacing: 14
  Label { text: "Network"; font.pixelSize: 32; color: "white" }
  TextArea { id: state; readOnly: true; Layout.fillWidth: true; Layout.fillHeight: true; color: "white"; text: JSON.stringify(systemControl.networkState(), null, 2); wrapMode: TextEdit.Wrap }
  RowLayout {
   Layout.fillWidth: true
   Button { text: "Refresh"; onClicked: state.text = JSON.stringify(systemControl.networkState(), null, 2) }
   Button { text: "Enable"; onClicked: { systemControl.setNetworkEnabled(true); state.text = JSON.stringify(systemControl.networkState(), null, 2) } }
   Button { text: "Disable"; onClicked: { systemControl.setNetworkEnabled(false); state.text = JSON.stringify(systemControl.networkState(), null, 2) } }
  }
 }
}