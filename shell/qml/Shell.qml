import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Item {
    id: shell
    anchors.fill: parent
    Rectangle { anchors.fill: parent; color: "#090b10" }
    Rectangle {
        id: taskbar
        width: parent.width * 0.56; height: 58; radius: 29
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottomMargin: 14
        color: "#171a22"; opacity: 0.96; border.color: "#343947"; border.width: 1
        RowLayout {
            anchors.fill: parent; anchors.margins: 9; spacing: 8
            ToolButton { text: "⊞"; font.pixelSize: 25; onClicked: start.visible = !start.visible }
            ToolButton { text: "⌕"; font.pixelSize: 23; onClicked: search.visible = !search.visible }
            Item { Layout.fillWidth: true }
            Label { text: Qt.formatDateTime(new Date(), "ddd  HH:mm"); color: "#e9edf7"; font.pixelSize: 14 }
            ToolButton { text: "⌁"; onClicked: quick.visible = !quick.visible }
        }
    }
    Rectangle {
        id: start; visible: false
        width: 520; height: 350; radius: 20
        anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: taskbar.top; anchors.bottomMargin: 10
        color: "#151820"; border.color: "#343947"; border.width: 1
        ColumnLayout {
            anchors.fill: parent; anchors.margins: 20; spacing: 12
            Label { text: "WINUX11"; font.pixelSize: 28; color: "white" }
            Label { text: "Applications"; color: "#aeb6c7" }
            Button { text: "File Explorer" }
            Button { text: "Terminal" }
            Button { text: "Settings" }
        }
    }
    Rectangle {
        id: search; visible: false
        width: 600; height: 82; radius: 18
        anchors.horizontalCenter: parent.horizontalCenter; anchors.top: parent.top; anchors.topMargin: 24
        color: "#151820"; border.color: "#343947"
        TextField { anchors.fill: parent; anchors.margins: 10; placeholderText: "Search applications, files and settings…" }
    }
    Rectangle {
        id: quick; visible: false
        width: 270; height: 180; radius: 18
        anchors.right: parent.right; anchors.bottom: taskbar.top; anchors.rightMargin: 18; anchors.bottomMargin: 10
        color: "#151820"; border.color: "#343947"
        Column { anchors.fill: parent; anchors.margins: 16; spacing: 10
            Label { text: "Quick Settings"; color: "white" }
            Button { text: "Network" }
            Button { text: "Audio" }
            Button { text: "Bluetooth" }
        }
    }
}
