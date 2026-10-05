import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"visible:true;width:700;height:500;title:"WINUX11 Clock";color:"#090b10"
 Timer{interval:1000;running:true;repeat:true;onTriggered:clock.text=Qt.formatDateTime(new Date(),"HH:mm:ss");Component.onCompleted:clock.text=Qt.formatDateTime(new Date(),"HH:mm:ss")}
 Column{anchors.centerIn:parent;spacing:12
  Label{id:clock;text:"00:00:00";font.pixelSize:82;color:"white"}
  Label{text:Qt.formatDateTime(new Date(),"dddd, dd MMMM yyyy");font.pixelSize:24;color: "white"}
 }
}
