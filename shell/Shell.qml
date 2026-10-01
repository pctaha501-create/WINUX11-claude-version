import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 visible:true;visibility:Window.FullScreen;title:"WINUX11 Shell";color:"#090b10";flags:Qt.FramelessWindowHint
 Rectangle{anchors.fill:parent;color:"#090b10"}
 Rectangle{id:taskbar;width:parent.width*.60;height:58;radius:29;anchors.bottom:parent.bottom;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottomMargin:14;color:"#171a22";border.color:"#343947"
  RowLayout{anchors.fill:parent;anchors.margins:8;spacing:5
   ToolButton{text:"⊞";font.pixelSize:25;onClicked:start.visible=!start.visible}ToolButton{text:"⌕";font.pixelSize:22;onClicked:search.visible=!search.visible}
   Repeater{model:shellController.windows;delegate:ToolButton{text:modelData.title||"Window";onClicked:shellController.command("activate "+index)}}
   Item{Layout.fillWidth:true}Label{text:"Desktop "+(shellController.workspace+1)+"  •  "+Qt.formatDateTime(new Date(),"ddd HH:mm");color:"#e9edf7"}ToolButton{text:"⌁";onClicked:quick.visible=!quick.visible}
  }
 }
 Rectangle{id:start;visible:false;width:620;height:430;radius:20;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:taskbar.top;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  ColumnLayout{anchors.fill:parent;anchors.margins:20;spacing:9;Label{text:"WINUX11";font.pixelSize:28;color:"white"}Label{text:"Applications";color:"#aeb6c7"}
   GridLayout{columns:3;columnSpacing:8;rowSpacing:8
    Button{text:"Files";onClicked:shellController.command("launch Files")}Button{text:"Terminal";onClicked:shellController.command("launch Terminal")}Button{text:"Browser";onClicked:shellController.command("launch Browser")}
    Button{text:"Settings";onClicked:shellController.command("launch Settings")}Button{text:"Task Manager";onClicked:shellController.command("launch Task Manager")}Button{text:"Security";onClicked:shellController.command("launch Security Center")}
    Button{text:"Software Center";onClicked:shellController.command("launch Software Center")}Button{text:"Network";onClicked:shellController.command("launch Network")}Button{text:"Screenshot";onClicked:shellController.command("launch Screenshot")}
   }
  }
 }
 Rectangle{id:search;visible:false;width:620;height:80;radius:18;anchors.horizontalCenter:parent.horizontalCenter;anchors.top:parent.top;anchors.topMargin:24;color:"#151820";border.color:"#343947";TextField{anchors.fill:parent;anchors.margins:10;placeholderText:"Application name";onAccepted:shellController.command("launch "+text)}}
 Rectangle{id:quick;visible:false;width:300;height:190;radius:18;anchors.right:parent.right;anchors.bottom:taskbar.top;anchors.rightMargin:18;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  Column{anchors.fill:parent;anchors.margins:16;spacing:9;Label{text:"Quick Settings";color:"white"}Button{text:"Maximize Active";onClicked:shellController.command("maximize")}Button{text:"Fullscreen Active";onClicked:shellController.command("fullscreen")}Label{text:"Ctrl+F1..F4  •  Alt+Tab  •  Super+Arrows";color:"#9ca8bb"}}
 }
}
