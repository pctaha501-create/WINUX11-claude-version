import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"visible:true;width:720;height:320;title:"WINUX11 Music";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:12;TextField{id:path;width:620;placeholderText:"audio file"}Button{text:"Play";onClicked:status.text=media.play(path.text)?"Playing":"No audio player available"}Label{id:status;color: "white"}}
}
