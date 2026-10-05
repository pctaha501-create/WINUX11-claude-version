import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"visible:true;width:720;height:360;title:"WINUX11 Camera";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:12;TextField{id:device;width:620;text:"/dev/video0"}TextField{id:path;width:620;text:"camera.jpg"}Button{text:"Capture";onClicked:status.text=media.captureCamera(device.text,path.text)?"Captured":"Camera/ffmpeg unavailable"}Label{id:status;color: "white"}}
}
