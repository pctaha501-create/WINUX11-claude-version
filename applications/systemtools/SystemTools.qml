import QtQuick
import QtQuick.Controls
ApplicationWindow{visible:true;width:900;height:600;title:"WINUX11 System Tools";color:"#090b10"
 Column{anchors.fill:parent;anchors.margins:18;spacing:12
  Label{text:"System Tools — "+toolMode;font.pixelSize:30;color:"white"}
  Button{text:"Refresh";onClicked:output.text=systemTools.query(toolMode)}
  TextArea{id:output;readOnly:true;anchors.left:parent.left;anchors.right:parent.right;height:470;color:"#e8edf7";background:Rectangle{color:"#11151d";radius:12};text:systemTools.query(toolMode)}
 }
}
