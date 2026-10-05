import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:520;height:250;title:"WINUX11 Screenshot";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:14
  Label{text:"Screenshot";color:"white";font.pixelSize:28}
  TextField{id:path;width:400;text:"screenshot.png"}
  Button{text:"Capture";onClicked:status.text=screenshotService.captureScreen(path.text)?"Saved":"No supported screenshot backend found"}
  Label{id:status;color: "white"}
 }
}
