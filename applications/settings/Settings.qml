import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
    visible:true; width:1000; height:700
    title:"WINUX11 Settings"; color:"white"
    property var info: systemInfo.snapshot()
    ColumnLayout {
        anchors.fill:parent; anchors.margins:24; spacing:14
        Label { text:"Settings"; color:"white"; font.pixelSize:34 }
        TabBar {
            id:tabs; Layout.fillWidth:true
            TabButton{text:"System"} TabButton{text:"Network"} TabButton{text:"Audio"} TabButton{text:"Storage"} TabButton{text:"Users"}
        }
        StackLayout { currentIndex:tabs.currentIndex; Layout.fillWidth:true; Layout.fillHeight:true
            ScrollView { TextArea { readOnly:true; text:JSON.stringify(info,null,2); color: "white"; background:Rectangle{color:"white";radius:14} } }
            Column { spacing:12
                Label{text:JSON.stringify(systemControl.networkState(),null,2);color: "white"}
                Button{text:"Enable Network";onClicked:{var ok=systemControl.setNetworkEnabled(true);status.text=ok?"Network enabled":"Network change failed"}}
                Button{text:"Disable Network";onClicked:{var ok=systemControl.setNetworkEnabled(false);status.text=ok?"Network disabled":"Network change failed"}}
            }
            Column { spacing:12
                Label{text:JSON.stringify(systemControl.audioState(),null,2);color: "white"}
                Slider{id:volume;from:0;to:100;value:50}
                Button{text:"Apply Volume";onClicked:status.text=systemControl.setAudioVolume(volume.value)?"Volume applied":"Volume change failed"}
            }
            ScrollView { TextArea{readOnly:true;text:JSON.stringify(systemControl.storageState(),null,2);color: "white";background:Rectangle{color:"white";radius:14}}}
            ListView { model:systemControl.users(); delegate:Label{text:modelData.name+"  UID "+modelData.uid+"  "+modelData.home;color: "white";height:32} }
        }
    }
}
