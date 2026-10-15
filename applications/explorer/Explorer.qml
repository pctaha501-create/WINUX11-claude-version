import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 palette.windowText:"white";palette.text:"white";palette.buttonText:"white";palette.brightText:"white";palette.highlightedText:"white";palette.placeholderText:"white"
 visible:true;width:1200;height:760;title:"WINUX11 Files";color:"#0a0d12"
 property string currentPath:homePath
 property string selectedPath:""
 property string clipboardPath:""
 property bool cutMode:false
 property string searchText:""
 property string actionStatus:""
 property bool showingTrash:false
 property var history:[homePath]
 property int historyIndex:0
 function refresh(){list.model=showingTrash?filesystem.trashList():filesystem.list(currentPath,hidden.checked).filter(function(x){return searchText===""||x.name.toLowerCase().indexOf(searchText.toLowerCase())>=0})}
 function navigate(path){if(!path||path===currentPath)return;showingTrash=false;currentPath=path;if(historyIndex<history.length-1)history=history.slice(0,historyIndex+1);history.push(path);historyIndex=history.length-1;selectedPath="";refresh()}
 function goBack(){if(historyIndex>0){showingTrash=false;historyIndex--;currentPath=history[historyIndex];refresh()}}
 function goForward(){if(historyIndex<history.length-1){showingTrash=false;historyIndex++;currentPath=history[historyIndex];refresh()}}
 function parentDir(){var p=currentPath.lastIndexOf("/");if(p>0)navigate(currentPath.slice(0,p))}
 function targetFor(name){return currentPath+(currentPath.endsWith("/")?"":"/")+name}
 function openFile(path){var lower=path.toLowerCase();if(lower.endsWith(".exe")||lower.endsWith(".msi")){actionStatus=wineManager.launch(path,[],"")?"Started Windows app: "+path.split("/").pop():"Could not launch Windows app. Install Wine in Software Center first."}else{actionStatus=filesystem.openPath(path)?"Opening: "+path.split("/").pop():"Could not open file."}}
 ColumnLayout{anchors.fill:parent;spacing:0
  Rectangle{Layout.fillWidth:true;height:42;color:"#20242b";RowLayout{anchors.fill:parent;anchors.leftMargin:12;anchors.rightMargin:12
   Label{text:"WINUX11";font.bold:true;font.pixelSize:18;color:"white"}
   Label{text:"  ›  Files";color:"#cbd5e1"}
   Item{Layout.fillWidth:true}
   Button{text:"—";onClicked:root.showMinimized()}
   Button{text:"□";onClicked:root.visibility=root.visibility===Window.Maximized?Window.Windowed:Window.Maximized}
   Button{text:"×";onClicked:root.close()}
  }}
  RowLayout{Layout.fillWidth:true;Layout.fillHeight:true;spacing:0
   Rectangle{Layout.preferredWidth:205;Layout.fillHeight:true;color:"#141820";ColumnLayout{anchors.fill:parent;anchors.margins:12;spacing:7
    Label{text:"Quick access";color:"white";font.bold:true}
    Repeater{model:[["Home",homePath],["Desktop",homePath+"/Desktop"],["Documents",homePath+"/Documents"],["Downloads",homePath+"/Downloads"],["Pictures",homePath+"/Pictures"],["Music",homePath+"/Music"],["Videos",homePath+"/Videos"]]
     delegate:Button{Layout.fillWidth:true;text:"  "+modelData[0];onClicked:navigate(modelData[1]);background:Rectangle{color:currentPath===modelData[1]?"#303a49":"transparent";radius:6}}
    }
    Item{Layout.fillHeight:true}
    Button{Layout.fillWidth:true;text:"Trash";onClicked:{showingTrash=true;selectedPath="";refresh()}}
    Label{text:"Linux files · Windows apps via Wine";color:"#94a3b8";wrapMode:Text.Wrap;Layout.fillWidth:true}
   }}
   ColumnLayout{Layout.fillWidth:true;Layout.fillHeight:true;spacing:10
    RowLayout{Layout.fillWidth:true;Layout.margins:12
     Button{text:"←";onClicked:goBack();enabled:historyIndex>0}
     Button{text:"→";onClicked:goForward();enabled:historyIndex<history.length-1}
     Button{text:"↑";onClicked:parentDir();enabled:!showingTrash}
     TextField{Layout.fillWidth:true;text:showingTrash?"Trash":currentPath;readOnly:showingTrash;onAccepted:navigate(text)}
     TextField{placeholderText:"Search this folder";onTextChanged:searchText=text}
     CheckBox{id:hidden;text:"Hidden files";onToggled:refresh()}
    }
    RowLayout{Layout.fillWidth:true;Layout.leftMargin:12;Layout.rightMargin:12
     Button{text:"New folder";enabled:!showingTrash;onClicked:{filesystem.createDirectory(targetFor("New Folder"));refresh()}}
     Button{text:"New file";enabled:!showingTrash;onClicked:{filesystem.createFile(targetFor("New File.txt"));refresh()}}
     Button{text:"Rename";enabled:!showingTrash&&selectedPath.length>0;onClicked:renameDialog.open()}
     Button{text:"Copy";enabled:!showingTrash&&selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=false}}
     Button{text:"Cut";enabled:!showingTrash&&selectedPath.length>0;onClicked:{clipboardPath=selectedPath;cutMode=true}}
     Button{text:"Paste";enabled:!showingTrash&&clipboardPath.length>0;onClicked:{var target=targetFor(clipboardPath.split("/").pop());var ok=cutMode?filesystem.movePath(clipboardPath,target):filesystem.copyPath(clipboardPath,target);if(ok)clipboardPath="";actionStatus=ok?"File operation completed":"File operation failed";refresh()}}
     Item{Layout.fillWidth:true}
    }
    Rectangle{Layout.fillWidth:true;height:1;color:"#303744"}
    RowLayout{Layout.fillWidth:true;spacing:0
     Label{Layout.fillWidth:true;Layout.leftMargin:16;text:"Name";color:"#cbd5e1";font.bold:true}
     Label{Layout.preferredWidth:110;text:"Type";color:"#cbd5e1";font.bold:true}
     Label{Layout.preferredWidth:180;text:"Modified";color:"#cbd5e1";font.bold:true}
    }
    ListView{id:list;Layout.fillWidth:true;Layout.fillHeight:true;clip:true;model:[];delegate:ItemDelegate{width:list.width;height:44;highlighted:selectedPath===modelData.path
      onClicked:selectedPath=modelData.path
      onDoubleClicked:if(!showingTrash&&modelData.directory)navigate(modelData.path);else if(!showingTrash)openFile(modelData.path)
      contentItem:RowLayout{spacing:12
       Label{text:(modelData.directory?"📁 ":"📄 ")+modelData.name;color:"white";Layout.fillWidth:true;elide:Text.ElideMiddle}
       Label{text:modelData.directory?"Folder":String(modelData.size)+" B";color:"#cbd5e1";Layout.preferredWidth:110}
       Label{text:Qt.formatDateTime(modelData.modified,"yyyy-MM-dd HH:mm");color:"#94a3b8";Layout.preferredWidth:180}
      }
      background:Rectangle{color:selectedPath===modelData.path?"#27364b":(index%2===0?"#0f131a":"#111720")}
    }}
    Label{Layout.fillWidth:true;Layout.leftMargin:12;text:actionStatus.length? actionStatus:(selectedPath.length?selectedPath:"Ready");color:"white";elide:Text.ElideMiddle}
   }
  }
 }
 Dialog{id:renameDialog;modal:true;title:"Rename";standardButtons:Dialog.Ok|Dialog.Cancel
  property string source:selectedPath
  TextField{id:newName;placeholderText:"New name"}
  onAccepted:{if(source&&newName.text){filesystem.renamePath(source,currentPath+"/"+newName.text);refresh();selectedPath=""}newName.text=""}
 }
 Component.onCompleted:refresh()
}
