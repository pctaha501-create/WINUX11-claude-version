import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
 visible:true;width:900;height:650;title:"WINUX11 Software Center";color:"#090b10"
 property var updates:packages.upgradable()
 ColumnLayout{anchors.fill:parent;anchors.margins:22;spacing:12
  Label{text:"Software Center";font.pixelSize:32;color:"white"}
  RowLayout{Button{text:"Refresh";onClicked:updates=packages.upgradable()}TextField{id:pkg;placeholderText:"Package name"}Button{text:"Install";onClicked:packages.install(pkg.text)}Button{text:"Remove";onClicked:packages.remove(pkg.text)}}
  ListView{Layout.fillWidth:true;Layout.fillHeight:true;model:updates;delegate:Label{text:modelData;color: "white";height:30}}
 }
}
