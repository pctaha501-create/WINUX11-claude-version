import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 visible:true;width:1100;height:700;title:"WINUX11 Files";color:"#0a0d12"
 property string currentPath:homePath
 property string selectedPath:""
 property string clipboardPath:""
 property bool cutMode:false
 function refresh(){list.model=filesystem.list(currentPath,hidden.checked)}
 ColumnLayout{anchors.fill:parent;anchors.margins:12;spacing:10
  RowLayout{Layout.fillWidth:true
   Button{text:"←";onClicked:{const p=currentPath.lastIndexOf("/");if(p>0){currentPath=currentPath.slice(0,p);refresh()}}}
   Button{text:"↑";onClicked:{const p=currentPath.lastIndexOf("/");if(p>0){currentPath=currentPath.slice(0,p);refresh()}}}
   TextField{Layout.fillWidth:true;text:currentPath;onAccepted:{currentPath=text;refresh()}}
   Button{text:"New Folder";onClicked:{filesystem.createDirectory(currentPath+"/New Folder");refresh()}}
   Button{text:"New File";onClicked:{filesystem.createFile(currentPath+"/New File.txt");refresh()}}
  }
  RowLayout{Layout.fillWidth:true
   Button{text:"Copy";enabled:selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=false}}
   Button{text:"Cut";enabled:selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=true}}
   Button{text:"Paste";enabled:clipboardPath.length>0;onClicked:{const target=currentPath+"/"+clipboardPath.split("/").pop();if(cutMode)filesystem.movePath(clipboardPath,target);else filesystem.copyPath(clipboardPath,target);clipboardPath="";refresh()}}
   Button{text:"Trash";enabled:selectedPath.length>0;onClicked:{filesystem.trashPath(selectedPath);selectedPath="";refresh()}}
   Button{text:"Delete";enabled:selectedPath.length>0;onClicked:{filesystem.removePath(selectedPath);selectedPath="";refresh()}}
   CheckBox{id:hidden;text:"Hidden files";onToggled:refresh()}
   Item{Layout.fillWidth:true}
   Label{text:selectedPath?selectedPath:"No selection";color:"#aeb8c9";elide:Text.ElideMiddle;Layout.preferredWidth:420}
  }
  ListView{id:list;Layout.fillWidth:true;Layout.fillHeight:true;clip:true
   delegate:ItemDelegate{
    width:list.width
    highlighted:currentPath===modelData.path
    text:modelData.name+(modelData.directory?"/":"")
    onClicked:selectedPath=modelData.path
    onDoubleClicked:if(modelData.directory){currentPath=modelData.path;selectedPath="";refresh()}
    contentItem:RowLayout{spacing:12
     Label{Layout.fillWidth:true;text:modelData.name+(modelData.directory?"/":"");color:"white"}
     Label{text:modelData.directory?"Folder":String(modelData.size)+" B";color:"#8f9bb0"}
     Label{text:Qt.formatDateTime(modelData.modified,"yyyy-MM-dd HH:mm");color:"#8f9bb0";Layout.preferredWidth:160}
    }
    Menu{
     id:context
     MenuItem{text:"Copy";onTriggered:{clipboardPath=modelData.path;cutMode=false}}
     MenuItem{text:"Cut";onTriggered:{clipboardPath=modelData.path;cutMode=true}}
     MenuItem{text:"Trash";onTriggered:{filesystem.trashPath(modelData.path);refresh()}}
    }
    TapHandler{acceptedButtons:Qt.RightButton;onTapped:context.popup()}
   }
  }
 }
 Component.onCompleted:refresh()
}
