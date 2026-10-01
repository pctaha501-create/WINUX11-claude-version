import QtQuick
import QtQuick.Controls
ApplicationWindow{visible:true;width:720;height:320;title:"WINUX11 Media Player";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:12;TextField{id:path;width:620;placeholderText:"media file"}Button{text:"Play";onClicked:status.text=media.play(path.text)?"Started":"No player or handler available"}Label{id:status;color:"#b9c5d8"}}
}
