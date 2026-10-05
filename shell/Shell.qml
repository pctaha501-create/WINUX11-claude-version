import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;visibility:Window.FullScreen;title:"WINUX11 Shell";color:"#090b10";flags:Qt.FramelessWindowHint
 Rectangle{anchors.fill:parent;color:"#090b10"}
 Rectangle{id:taskbar;width:parent.width*.60;height:58;radius:29;anchors.bottom:parent.bottom;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottomMargin:14;color:"#171a22";border.color:"#343947"
  RowLayout{anchors.fill:parent;anchors.margins:8;spacing:5
   ToolButton{text:"⊞";font.pixelSize:25;onClicked:start.visible=!start.visible}ToolButton{text:"⌕";font.pixelSize:22;onClicked:search.visible=!search.visible}
   Repeater{model:shellController.windows;delegate:ToolButton{text:modelData.title||"Window";onClicked:shellController.command("activate "+index)}}
   Item{Layout.fillWidth:true}Label{text:"Desktop "+(shellController.workspace+1)+"  •  "+Qt.formatDateTime(new Date(),"ddd HH:mm");color:"white"}ToolButton{text:"⌁";onClicked:quick.visible=!quick.visible}
  }
 }
 Rectangle{id:start;visible:false;width:850;height:560;radius:20;anchors.horizontalCenter:parent.horizontalCenter;anchors.bottom:taskbar.top;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  ColumnLayout{anchors.fill:parent;anchors.margins:20;spacing:9;Label{text:"WINUX11";font.pixelSize:28;color:"white"}Label{text:"Applications";color:"white"}
   GridLayout{columns:5;columnSpacing:8;rowSpacing:8
    Button{text:"Files";onClicked:shellController.command("launch Files")}Button{text:"Terminal";onClicked:shellController.command("launch Terminal")}Button{text:"Browser";onClicked:shellController.command("launch Browser")}Button{text:"Settings";onClicked:shellController.command("launch Settings")}Button{text:"Task Manager";onClicked:shellController.command("launch Task Manager")}
    Button{text:"Security";onClicked:shellController.command("launch Security Center")}Button{text:"Software";onClicked:shellController.command("launch Software Center")}Button{text:"Network";onClicked:shellController.command("launch Network")}Button{text:"Downloader";onClicked:shellController.command("launch Downloader")}Button{text:"Archive";onClicked:shellController.command("launch Archive Manager")}
    Button{text:"Screenshot";onClicked:shellController.command("launch Screenshot")}Button{text:"Calculator";onClicked:shellController.command("launch Calculator")}Button{text:"Clock";onClicked:shellController.command("launch Clock")}Button{text:"Calendar";onClicked:shellController.command("launch Calendar")}Button{text:"Text Editor";onClicked:shellController.command("launch Text Editor")}Button{text:"Photos";onClicked:shellController.command("launch Photos")}
    Button{text:"Media Player";onClicked:shellController.command("launch Media Player")}Button{text:"Music";onClicked:shellController.command("launch Music")}Button{text:"Camera";onClicked:shellController.command("launch Camera")}Button{text:"Voice Recorder";onClicked:shellController.command("launch Voice Recorder")}Button{text:"Disk";onClicked:shellController.command("launch Disk Management")}
    Button{text:"Updates";onClicked:shellController.command("launch Update Manager")}Button{text:"Startup";onClicked:shellController.command("launch Startup Apps")}Button{text:"Printers";onClicked:shellController.command("launch Printer Manager")}Button{text:"Display";onClicked:shellController.command("launch Display Manager")}Button{text:"Sound";onClicked:shellController.command("launch Sound Manager")}
    Button{text:"Bluetooth";onClicked:shellController.command("launch Bluetooth Manager")}Button{text:"Wi-Fi";onClicked:shellController.command("launch Wi-Fi Manager")}Button{text:"Privacy";onClicked:shellController.command("launch Privacy Center")}
   }
  }
 }
 Rectangle{id:search;visible:false;width:620;height:80;radius:18;anchors.horizontalCenter:parent.horizontalCenter;anchors.top:parent.top;anchors.topMargin:24;color:"#151820";border.color:"#343947";TextField{anchors.fill:parent;anchors.margins:10;placeholderText:"Application name";onAccepted:shellController.command("launch "+text)}}
 
 Rectangle{id:clipboard;visible:false;width:460;height:300;radius:18;anchors.right:parent.right;anchors.bottom:taskbar.top;anchors.rightMargin:18;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  Column{anchors.fill:parent;anchors.margins:16;spacing:10
   Label{text:"Clipboard";font.pixelSize:22;color:"white"}
   TextArea{id:clipText;width:parent.width;height:180;text:shellController.clipboardText();color:"white";background:Rectangle{color:"#0d1017";radius:10};wrapMode:TextEdit.Wrap}
   Row{spacing:8
    Button{text:"Copy";onClicked:shellController.setClipboardText(clipText.text)}
    Button{text:"Refresh";onClicked:clipText.text=shellController.clipboardText()}
    Button{text:"Clear";onClicked:{shellController.clearClipboard();clipText.text=""}}
   }
  }
 }

 Rectangle{id:quick;visible:false;width:300;height:190;radius:18;anchors.right:parent.right;anchors.bottom:taskbar.top;anchors.rightMargin:18;anchors.bottomMargin:10;color:"#151820";border.color:"#343947"
  Column{anchors.fill:parent;anchors.margins:16;spacing:9;Label{text:"Quick Settings";color:"white"}Button{text:"Network";onClicked:shellController.command("launch Network")}Button{text:"Sound";onClicked:shellController.command("launch Sound Manager")}Button{text:"Display";onClicked:shellController.command("launch Display Manager")}Label{text:"Ctrl+F1..F4  •  Alt+Tab  •  Super+Arrows";color: "white"}}
 }
}
