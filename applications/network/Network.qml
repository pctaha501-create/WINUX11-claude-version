import QtQuick
import QtQuick.Controls
ApplicationWindow{
 visible:true;width:820;height:520;title:"WINUX11 Network";color:"#090b10"
 Column{anchors.fill:parent;anchors.margins:22;spacing:14
  Label{text:"Network";font.pixelSize:32;color:"white"}
  TextArea{id:state;readOnly:true;width:parent.width;height:250;color:"#e8edf7";background:Rectangle{color:"#11151d";radius:12};text:JSON.stringify(systemControl.networkState(),null,2)}
  Row{spacing:10;Button{text:"Refresh";onClicked:state.text=JSON.stringify(systemControl.networkState(),null,2)}Button{text:"Enable";onClicked:systemControl.setNetworkEnabled(true)}Button{text:"Disable";onClicked:systemControl.setNetworkEnabled(false)}}
 }
}
