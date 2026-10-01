import QtQuick
import QtQuick.Controls
ApplicationWindow{visible:true;width:1000;height:700;title:"WINUX11 Photos";color:"#090b10"
 Column{anchors.fill:parent;anchors.margins:14;spacing:10
  Row{spacing:8;TextField{id:path;width:760;placeholderText:"/path/to/image.png"}Button{text:"Open";onClicked:image.source=Qt.resolvedUrl("file://"+path.text)}}
  Image{id:image;anchors.horizontalCenter:parent.horizontalCenter;width:900;height:600;fillMode:Image.PreserveAspectFit}
 }
}
