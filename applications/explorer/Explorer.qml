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
 property bool showingTrash:false
 property var history:[homePath]
 property int historyIndex:0
 function refresh(){list.model=showingTrash?filesystem.trashList():filesystem.list(currentPath,hidden.checked).filter(function(x){return searchText===""||x.name.toLowerCase().indexOf(searchText.toLowerCase())>=0})}
 function navigate(path){if(!path||path===currentPath)return;showingTrash=false;currentPath=path;if(historyIndex<history.length-1)history=history.slice(0,historyIndex+1);history.push(path);historyIndex=history.length-1;selectedPath="";refresh()}
 function goBack(){if(historyIndex>0){showingTrash=false;historyIndex--;currentPath=history[historyIndex];refresh()}}
 function goForward(){if(historyIndex<history.length-1){showingTrash=false;historyIndex++;currentPath=history[historyIndex];refresh()}}
 function parentDir(){var p=currentPath.lastIndexOf("/");if(p>0)navigate(currentPath.slice(0,p))}
 function targetFor(name){return currentPath+"/"+name}
 ColumnLayout{anchors.fill:parent;anchors.margins:12;spacing:10
  RowLayout{Layout.fillWidth:true
   Button{text:"←";enabled:!showingTrash&&historyIndex>0;onClicked:goBack()}
   Button{text:"→";enabled:!showingTrash&&historyIndex<history.length-1;onClicked:goForward()}
   Button{text:"↑";enabled:!showingTrash;onClicked:parentDir()}
   TextField{Layout.fillWidth:true;text:showingTrash?"Trash":currentPath;readOnly:showingTrash;onAccepted:navigate(text)}
   TextField{Layout.preferredWidth:220;placeholderText:"Search";onTextChanged:{searchText=text;refresh()}}
   Button{text:showingTrash?"Home":"Trash";onClicked:{showingTrash=!showingTrash;selectedPath="";refresh()}}
  }
  RowLayout{Layout.fillWidth:true
   Button{text:"New Folder";enabled:!showingTrash;onClicked:{filesystem.createDirectory(targetFor("New Folder"));refresh()}}
   Button{text:"New File";enabled:!showingTrash;onClicked:{filesystem.createFile(targetFor("New File.txt"));refresh()}}
   Button{text:"Rename";enabled:!showingTrash&&selectedPath.length>0;onClicked:renameDialog.open()}
   Button{text:"Copy";enabled:!showingTrash&&selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=false}}
   Button{text:"Cut";enabled:!showingTrash&&selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=true}}
   Button{text:"Paste";enabled:!showingTrash&&clipboardPath.length>0;onClicked:{var target=targetFor(clipboardPath.split("/").pop());var ok=cutMode?filesystem.movePath(clipboardPath,target):filesystem.copyPath(clipboardPath,target);if(ok)clipboardPath="";refresh()}}
   Button{text:"Restore";visible:showingTrash;enabled:selectedPath.length>0;onClicked:{filesystem.restoreTrash(selectedPath.split("/").pop());selectedPath="";refresh()}}
   Button{text:showingTrash?"Delete Forever":"Trash";enabled:selectedPath.length>0;onClicked:{if(showingTrash)filesystem.deleteTrash(selectedPath.split("/").pop());else filesystem.trashPath(selectedPath);selectedPath="";refresh()}}
   Button{text:"Delete";visible:!showingTrash;enabled:selectedPath.length>0;onClicked:{filesystem.removePath(selectedPath);selectedPath="";refresh()}}
   CheckBox{id:hidden;text:"Hidden files";visible:!showingTrash;onToggled:refresh()}
   Item{Layout.fillWidth:true}
   Label{text:selectedPath?selectedPath:"No selection";color:"#aeb8c9";elide:Text.ElideMiddle;Layout.preferredWidth:320}
  }
  ListView{id:list;Layout.fillWidth:true;Layout.fillHeight:true;clip:true
   delegate:ItemDelegate{
    width:list.width;text:modelData.name+(modelData.directory?"/":"")
    onClicked:selectedPath=modelData.path
    onDoubleClicked:if(!showingTrash&&modelData.directory)navigate(modelData.path);else if(!showingTrash)filesystem.openPath(modelData.path)
    contentItem:RowLayout{spacing:12
     Label{Layout.fillWidth:true;text:modelData.name+(modelData.directory?"/":"");color:"white"}
     Label{text:modelData.directory?"Folder":String(modelData.size)+" B";color:"#8f9bb0"}
     Label{text:Qt.formatDateTime(modelData.modified,"yyyy-MM-dd HH:mm");color:"#8f9bb0";Layout.preferredWidth:160}
    }
    Menu{id:context
     MenuItem{text:"Open";enabled:!showingTrash;onTriggered:if(modelData.directory)navigate(modelData.path);else filesystem.openPath(modelData.path)}
     MenuItem{text:"Copy";enabled:!showingTrash;onTriggered:{clipboardPath=modelData.path;cutMode=false}}
     MenuItem{text:"Cut";enabled:!showingTrash;onTriggered:{clipboardPath=modelData.path;cutMode=true}}
     MenuItem{text:"Rename";enabled:!showingTrash;onTriggered:{selectedPath=modelData.path;renameDialog.open()}}
     MenuItem{text:showingTrash?"Restore":"Trash";onTriggered:{if(showingTrash)filesystem.restoreTrash(modelData.name);else filesystem.trashPath(modelData.path);refresh()}}
    }
    TapHandler{acceptedButtons:Qt.RightButton;onTapped:context.popup()}
   }
  }
 }
 Dialog{id:renameDialog;modal:true;title:"Rename";standardButtons:Dialog.Ok|Dialog.Cancel
  property string source:selectedPath
  TextField{id:newName;anchors.fill:parent;placeholderText:"New name"}
  onAccepted:{if(source&&newName.text)filesystem.renamePath(source,currentPath+"/"+newName.text);newName.text="";refresh();selectedPath=""}
 }
 Component.onCompleted:refresh()
}