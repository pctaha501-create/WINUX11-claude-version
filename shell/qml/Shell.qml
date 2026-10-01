import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    color: "#090b10"
    title: "WINUX11"
    Rectangle { anchors.fill: parent; color: "#090b10" }
    Rectangle {
        id: taskbar
        width: parent.width * 0.56
        height: 58
        radius: 29
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 14
        color: "#171a22"
        opacity: 0.96
        border.color: "#343947"
        border.width: 1
        RowLayout {
            anchors.fill: parent
            anchors.margins: 9
            spacing: 8
            ToolButton { text: "⊞"; font.pixelSize: 25; onClicked: start.open() }
            ToolButton { text: "⌕"; font.pixelSize: 23; onClicked: search.open() }
            Item { Layout.fillWidth: true }
            Label {
                text: Qt.formatDateTime(new Date(), "ddd  HH:mm")
                color: "#e9edf7"
                font.pixelSize: 14
            }
            ToolButton { text: "⌁"; onClicked: quick.open() }
        }
    }
    Popup {
        id: start
        x: parent.width / 2 - 260
        y: parent.height - 390
        width: 520
        height: 350
        modal: true
        background: Rectangle { radius: 20; color: "#151820"; border.color: "#343947" }
        contentItem: ColumnLayout {
            spacing: 12
            Label { text: "WINUX11"; font.pixelSize: 28; color: "white" }
            Label { text: "Applications"; color: "#aeb6c7" }
            Button { text: "File Explorer"; onClicked: Qt.openUrlExternally("file:///home") }
            Button { text: "Terminal"; onClicked: Qt.openUrlExternally("file:///usr/bin/x-terminal-emulator") }
            Button { text: "Settings" }
        }
    }
    Popup {
        id: search
        x: parent.width / 2 - 300
        y: 70
        width: 600
        height: 90
        background: Rectangle { radius: 18; color: "#151820" }
        contentItem: TextField { placeholderText: "Search applications, files and settings…"; focus: true }
    }
    Popup {
        id: quick
        x: parent.width - 300
        y: parent.height - 250
        width: 270
        height: 180
        background: Rectangle { radius: 18; color: "#151820" }
        contentItem: Column {
            padding: 16
            spacing: 10
            Label { text: "Quick Settings"; color: "white" }
            Button { text: "Network" }
            Button { text: "Audio" }
            Button { text: "Bluetooth" }
        }
    }
}
