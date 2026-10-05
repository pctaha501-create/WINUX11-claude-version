import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:1000;height:700;title:"WINUX11 Security Center";color:"#090b10"
 ColumnLayout{anchors.fill:parent;anchors.margins:22;spacing:12
  Label{text:"Security Center";font.pixelSize:32;color:"white"}
  Button{text:"Refresh";onClicked:{ports.text=JSON.stringify(securityService.listeningPorts(),null,2);connections.text=JSON.stringify(securityService.activeConnections(),null,2);firewall.text=JSON.stringify(systemControl.firewallState(),null,2)}}
  Label{id:firewall;text:JSON.stringify(systemControl.firewallState(),null,2);color: "white"}
  TextArea{id:ports;Layout.fillWidth:true;Layout.fillHeight:true;readOnly:true;color: "white";text:JSON.stringify(securityService.listeningPorts(),null,2);background:Rectangle{color:"#11151d";radius:12}}
  TextArea{id:connections;Layout.fillWidth:true;Layout.fillHeight:true;readOnly:true;color: "white";text:JSON.stringify(securityService.activeConnections(),null,2);background:Rectangle{color:"#11151d";radius:12}}
 }
}
