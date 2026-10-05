import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:820;height:480;title:"WINUX11 Archive Manager";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:12
  Label{text:"Archive Manager";font.pixelSize:30;color:"white"}
  TextField{id:archive;width:650;placeholderText:"archive.tar"}
  TextField{id:path;width:650;placeholderText:"source or destination"}
  Row{spacing:10;Button{text:"Extract";onClicked:status.text=archiveService.extractTar(archive.text,path.text)?"Extracted":"Extraction failed"}Button{text:"Create TAR";onClicked:status.text=archiveService.createTar(path.text,archive.text)?"Created":"Creation failed"}}
  Label{id:status;color: "white"}
 }
}
