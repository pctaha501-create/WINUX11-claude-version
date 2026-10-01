import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtWebEngine
ApplicationWindow{
 visible:true;width:1280;height:820;title:"WINUX11 Browser";color:"#090b10"
 property int currentTab:0
 property var tabs:[]
 function addTab(url){tabs.push({url:url||"https://www.qt.io",title:"New Tab"});currentTab=tabs.length-1;tabsChanged()}
 function closeTab(i){if(tabs.length===1){tabs=[{url:"https://www.qt.io",title:"New Tab"}]}else{tabs.splice(i,1);currentTab=Math.max(0,Math.min(currentTab,tabs.length-1))}tabsChanged()}
 Component.onCompleted:addTab("https://www.qt.io")
 ColumnLayout{anchors.fill:parent;spacing:0
  RowLayout{Layout.fillWidth:true
   Repeater{model:tabs.length;delegate:Button{text:tabs[index].title||"Tab";checkable:true;checked:index===currentTab;onClicked:currentTab=index;onDoubleClicked:closeTab(index)}}
   Button{text:"+";onClicked:addTab("https://www.qt.io")}
   Item{Layout.fillWidth:true}
   Button{text:"←";onClicked:page.goBack()}
   Button{text:"→";onClicked:page.goForward()}
   Button{text:"↻";onClicked:page.reload()}
  }
  RowLayout{Layout.fillWidth:true
   TextField{id:address;Layout.fillWidth:true;text:tabs.length?tabs[currentTab].url:"";selectByMouse:true;onAccepted:{if(text.indexOf("://")<0)text="https://www.google.com/search?q="+encodeURIComponent(text);page.url=text;tabs[currentTab].url=text}}
   Button{text:"★";onClicked:bookmarks.append(address.text)}
  }
  WebEngineView{id:page;Layout.fillWidth:true;Layout.fillHeight:true;url:tabs.length?tabs[currentTab].url:"https://www.qt.io";onUrlChanged:{if(tabs.length){tabs[currentTab].url=url.toString();address.text=url.toString()}};onTitleChanged:{if(tabs.length){tabs[currentTab].title=title;tabsChanged()}}}
 }
 property var bookmarks:[]
}