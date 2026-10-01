import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
ApplicationWindow {
    visible: true
    width: 1000
    height: 650
    title: "WINUX11 Files"
    color: "#0a0d12"
    property string currentPath: StandardPaths.writableLocation(StandardPaths.HomeLocation)
    ColumnLayout {
        anchors.fill: parent; anchors.margins: 12
        RowLayout {
            Layout.fillWidth: true
            Button { text: "↑"; onClicked: { const p=currentPath.lastIndexOf("/"); if(p>0) currentPath=currentPath.slice(0,p); list.model=filesystem.list(currentPath) } }
            TextField { Layout.fillWidth: true; text: currentPath; onAccepted: { currentPath=text; list.model=filesystem.list(currentPath) } }
            Button { text: "New Folder"; onClicked: { filesystem.createDirectory(currentPath + "/New Folder"); list.model=filesystem.list(currentPath) } }
        }
        ListView {
            id: list
            Layout.fillWidth: true; Layout.fillHeight: true
            delegate: ItemDelegate {
                width: list.width
                text: modelData.name + (modelData.directory ? "/" : "")
                onDoubleClicked: if (modelData.directory) { currentPath=modelData.path; list.model=filesystem.list(currentPath) }
            }
        }
    }
    Component.onCompleted: list.model = filesystem.list(currentPath)
}
