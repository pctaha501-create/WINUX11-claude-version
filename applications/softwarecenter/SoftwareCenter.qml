import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:900;height:650;title:"WINUX11 Software Center";color:"#090b10"
 property var updates:packages.upgradable()
 property bool wineAvailable:false
 function refreshWine(){var found=wineManager.detect();wineAvailable=false;for(var i=0;i<found.length;i++){if(found[i].name==="wine"&&found[i].available){wineAvailable=true;break}}}
 Component.onCompleted:refreshWine()
 ColumnLayout{anchors.fill:parent;anchors.margins:22;spacing:12
  Label{text:"Software Center";font.pixelSize:32;color:"white"}
  RowLayout{Button{text:"Refresh";onClicked:{updates=packages.upgradable();status.text="Package list refreshed"}}TextField{id:pkg;placeholderText:"Package name";Layout.fillWidth:true}Button{text:"Install";onClicked:status.text=packages.install(pkg.text)?"Install completed":"Install failed or authorization cancelled"}Button{text:"Remove";onClicked:status.text=packages.remove(pkg.text)?"Remove completed":"Remove failed or authorization cancelled"} }
  RowLayout {
   Label { text: wineAvailable ? "Windows app support: Wine installed" : "Windows app support: Wine not installed"; color: "white"; Layout.fillWidth: true }
   Button {
    text: wineAvailable ? "Refresh Wine" : "Install Wine"
    onClicked: {
     if (!wineAvailable)
      status.text = packages.install("wine") ? "Wine installed" : "Wine installation failed or was cancelled"
     refreshWine()
    }
   }
  }
  Label{id:status;text:"Ready";color:"white"}
  ListView{Layout.fillWidth:true;Layout.fillHeight:true;model:updates;delegate:Label{text:modelData;color: "white";height:30}}
 }
}
