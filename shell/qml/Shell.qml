import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Item{
 id:shell;anchors.fill:parent
 Rectangle{anchors.fill:parent;color:"#090b10"}
 Rectangle{id:taskbar;width:parent.width*.60;height:58;radius:29;anchors.bottom:parent.bottom;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottomMargin:14;color:"#171a22";opacity:.97;border.color:"#343947"
  RowLayout{anchors.fill:parent;anchors.margins:8;spacing:5
   ToolButton{text:"⊞";font.pixelSize:25;onClicked:start.visible=!start.visible}
   ToolButton{text:"⌕";font.pixelSize:22;onClicked:search.visible=!search.visible}
   Repeater{model:winuxCompositor.windowList
    delegate:ToolButton{text:modelData.title||"Window";onClicked:winuxCompositor.activateIndex(index)}
   }
   Item{Layout.fillWidth:true}
   Label{text:Qt.formatDateTime(new Date(),"ddd  HH:mm");color:"#e9edf7";font.pixelSize:14}
   ToolButton{text:"⌁";onClicked:quick.visible=!quick.visible}
  }
 }
 Rectangle{id:start;visible:false;width:560;height:420;radius:20;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:taskbar.top;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  ColumnLayout{anchors.fill:parent;anchors.margins:20;spacing:9
   Label{text:"WINUX11";font.pixelSize:28;color:"white"} Label{text:"Applications";color:"#aeb6c7"}
   RowLayout{Button{text:"Files";onClicked:winuxCompositor.launchApplication("Files")}Button{text:"Terminal";onClicked:winuxCompositor.launchApplication("Terminal")}Button{text:"Browser";onClicked:winuxCompositor.launchApplication("Browser")}}
   RowLayout{Button{text:"Settings";onClicked:winuxCompositor.launchApplication("Settings")}Button{text:"Task Manager";onClicked:winuxCompositor.launchApplication("Task Manager")}Button{text:"Security";onClicked:winuxCompositor.launchApplication("Security Center")}}
  }
 }
 Rectangle{id:search;visible:false;width:620;height:80;radius:18;anchors.horizontalCenter:parent.horizontalCenter;anchors.top:parent.top;anchors.topMargin:24;color:"#151820";border.color:"#343947";TextField{anchors.fill:parent;anchors.margins:10;placeholderText:"Search applications, files and settings…";onAccepted:{if(text.length)winuxCompositor.launchApplication(text);search.visible=false}}}
 Rectangle{id:quick;visible:false;width:280;height:190;radius:18;anchors.right:parent.right;anchors.bottom:taskbar.top;anchors.rightMargin:18;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  Column{anchors.fill:parent;anchors.margins:16;spacing:9;Label{text:"Quick Settings";color:"white"}Button{text:"Settings";onClicked:winuxCompositor.launchApplication("Settings")}Button{text:"Security Center";onClicked:winuxCompositor.launchApplication("Security Center")}Label{text:"Ctrl+F1..F4: Workspaces  •  Alt+Tab: Switch";color:"#9ca8bb"}}
 }
}
