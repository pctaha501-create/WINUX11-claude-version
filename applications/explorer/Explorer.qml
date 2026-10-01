import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 visible:true;width:1200;height:760;title:"WINUX11 Files";color:"#0a0d12"
 property string currentPath:homePath
 property string selectedPath:""
 property string clipboardPath:""
 property bool cutMode:false
 property string searchText:""
 property var history:[homePath]
 property int historyIndex:0
 function refresh(){list.model=filesystem.list(currentPath,hidden.checked).filter(function(x){return searchText===""||x.name.toLowerCase().indexOf(searchText.toLowerCase())>=0})}
 function navigate(path){if(!path||path===currentPath)return;currentPath=path;if(historyIndex<history.length-1)history=history.slice(0,historyIndex+1);history.push(path);historyIndex=history.length-1;selectedPath="";refresh()}
 function goBack(){if(historyIndex>0){historyIndex--;currentPath=history[historyIndex];refresh()}}
 function goForward(){if(historyIndex<history.length-1){historyIndex++;currentPath=history[historyIndex];refresh()}}
 function parent(){var p=currentPath.lastIndexOf("/");if(p>0)navigate(currentPath.slice(0,p))}
 function targetFor(name){return currentPath+"/"+name}
 ColumnLayout{anchors.fill:parent;anchors.margins:12;spacing:10
  RowLayout{Layout.fillWidth:true
   Button{text:"←";enabled:historyIndex>0;onClicked:goBack()}
   Button{text:"→";enabled:historyIndex<history.length-1;onClicked:goForward()}
   Button{text:"↑";onClicked:parent()}
   TextField{Layout.fillWidth:true;text:currentPath;onAccepted:navigate(text)}
   TextField{Layout.preferredWidth:220;placeholderText:"Search";onTextChanged:{searchText=text;refresh()}}
  }
  RowLayout{Layout.fillWidth:true
   Button{text:"New Folder";onClicked:{filesystem.createDirectory(targetFor("New Folder"));refresh()}}
   Button{text:"New File";onClicked:{filesystem.createFile(targetFor("New File.txt"));refresh()}}
   Button{text:"Rename";enabled:selectedPath.length>0;onClicked:renameDialog.open()}
   Button{text:"Copy";enabled:selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=false}}
   Button{text:"Cut";enabled:selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=true}}
   Button{text:"Paste";enabled:clipboardPath.length>0;onClicked:{var target=targetFor(clipboardPath.split("/").pop());var ok=cutMode?filesystem.movePath(clipboardPath,target):filesystem.copyPath(clipboardPath,target);if(ok)clipboardPath="";refresh()}}
   Button{text:"Trash";enabled:selectedPath.length>0;onClicked:{filesystem.trashPath(selectedPath);selectedPath="";refresh()}}
   Button{text:"Delete";enabled:selectedPath.length>0;onClicked:{filesystem.removePath(selectedPath);selectedPath="";refresh()}}
   CheckBox{id:hidden;text:"Hidden files";onToggled:refresh()}
   Item{Layout.fillWidth:true}
   Label{text:selectedPath?selectedPath:"No selection";color:"#aeb8c9";elide:Text.ElideMiddle;Layout.preferredWidth:360}
  }
  ListView{id:list;Layout.fillWidth:true;Layout.fillHeight:true;clip:true
   delegate:ItemDelegate{
    width:list.width
    text:modelData.name+(modelData.directory?"/":"")
    onClicked:selectedPath=modelData.path
    onDoubleClicked:if(modelData.directory)navigate(modelData.path);else filesystem.openPath?filesystem.openPath(modelData.path):null
    contentItem:RowLayout{spacing:12
     Label{Layout.fillWidth:true;text:modelData.name+(modelData.directory?"/":"");color:"white"}
     Label{text:modelData.directory?"Folder":String(modelData.size)+" B";color:"#8f9bb0"}
     Label{text:Qt.formatDateTime(modelData.modified,"yyyy-MM-dd HH:mm");color:"#8f9bb0";Layout.preferredWidth:160}
    }
    Menu{id:context
     MenuItem{text:"Open";onTriggered:if(modelData.directory)navigate(modelData.path)}
     MenuItem{text:"Copy";onTriggered:{clipboardPath=modelData.path;cutMode=false}}
     MenuItem{text:"Cut";onTriggered:{clipboardPath=modelData.path;cutMode=true}}
     MenuItem{text:"Rename";onTriggered:{selectedPath=modelData.path;renameDialog.open()}}
     MenuItem{text:"Trash";onTriggered:{filesystem.trashPath(modelData.path);refresh()}}
    }
    TapHandler{acceptedButtons:Qt.RightButton;onTapped:context.popup()}
   }
  }
 }
 Dialog{id:renameDialog;modal:true;title:"Rename";standardButtons:Dialog.Ok|Dialog.Cancel
  property string source:selectedPath
  TextField{id:newName;anchors.fill:parent;placeholderText:"New name"}
  onAccepted:{if(source&&newName.text)filesystem.renamePath(source,currentPath+"/"+newName.text);refresh();selectedPath=""}
 }
 Component.onCompleted:refresh()
}