import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:800;height:360;title:"WINUX11 Downloader";color:"#090b10"
 Column{anchors.centerIn:parent;spacing:12
  Label{text:"Downloader";font.pixelSize:30;color:"white"}
  TextField{id:url;width:650;placeholderText:"https://example.com/file"}
  TextField{id:dest;width:650;text:"download.bin"}
  Button{text:"Download";onClicked:status.text=downloads.download(url.text,dest.text)?"Started":"Invalid URL or destination"}
  Label{id:status;color: "white"}
 }
 Connections{target:downloads;function onFinished(ok,message){status.text=ok?"Saved: "+message:"Failed: "+message}}
}
