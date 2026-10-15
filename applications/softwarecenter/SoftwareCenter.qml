import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 palette.windowText:"white";palette.text:"white";palette.buttonText:"white";palette.brightText:"white";palette.highlightedText:"white";palette.placeholderText:"white"
 visible:true;width:900;height:650;title:"WINUX11 Software Center";color:"#090b10"
 property var updates:packages.upgradable()
 property bool wineAvailable:false
 function refreshWine(){var found=wineManager.detect();wineAvailable=false;for(var i=0;i<found.length;i++){if(found[i].name==="wine"&&found[i].available){wineAvailable=true;break}}}
 Component.onCompleted:refreshWine()
 ColumnLayout{anchors.fill:parent;anchors.margins:22;spacing:12
  Label{text:"Software Center";font.pixelSize:32;color:"white"}
  Label{text:"Install Linux tools and applications using your system package manager.";color:"#cbd5e1"}
  RowLayout{Layout.fillWidth:true
   Button{text:"Refresh";onClicked:{updates=packages.upgradable();status.text="Package list refreshed"}}
   TextField{id:pkg;placeholderText:"Package name (e.g. git, vlc, gimp)";Layout.fillWidth:true}
   Button{text:"Install";onClicked:status.text=packages.install(pkg.text)?"Install requested":"Install failed or authorization cancelled"}
   Button{text:"Remove";onClicked:status.text=packages.remove(pkg.text)?"Remove requested":"Remove failed or authorization cancelled"}
  }
  Rectangle{Layout.fillWidth:true;height:1;color:"#303744"}
  Label{text:"Windows application compatibility";font.pixelSize:22;color:"white"}
  RowLayout{Layout.fillWidth:true
   Label{Layout.fillWidth:true;text:wineAvailable?"Wine is installed — try compatible .exe and .msi installers":"Wine is not installed";color:"white"}
   Button{text:wineAvailable?"Refresh Wine":"Install Wine";onClicked:{if(!wineAvailable){status.text=packages.install("wine")?"Wine installation requested":"Wine installation failed or was cancelled"}refreshWine()}}
  }
  Label{text:"Compatibility varies by Windows app, driver, and Wine version. Some apps require extra components or may not run.";color:"#fbbf24";wrapMode:Text.Wrap;Layout.fillWidth:true}
  Label{id:status;text:"Ready";color:"white"}
  Label{text:"Available package updates";font.pixelSize:20;color:"white"}
  ListView{Layout.fillWidth:true;Layout.fillHeight:true;model:updates;delegate:Label{text:modelData;color:"white";height:30}}
 }
}
