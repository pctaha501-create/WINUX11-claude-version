import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    palette.windowText: "white"
    palette.text: "white"
    palette.buttonText: "white"
    palette.brightText: "white"
    palette.highlightedText: "white"
    palette.placeholderText: "white"
    visible: true
    visibility: Window.FullScreen
    title: "WINUX11 Shell"
    color: "#090b10"
    flags: Qt.FramelessWindowHint
    property date clockNow: new Date()
    Timer { interval: 15000; running: true; repeat: true; onTriggered: root.clockNow = new Date() }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#111827" }
            GradientStop { position: 0.52; color: "#0a1020" }
            GradientStop { position: 1.0; color: "#080b12" }
        }
    }

    Column {
        id: desktopShortcuts
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 18
        spacing: 10
        Repeater {
            model: [
                {label:"This PC", command:"Files", glyph:"▣"},
                {label:"Terminal", command:"Terminal", glyph:"⌘"},
                {label:"Browser", command:"Browser", glyph:"◎"},
                {label:"Settings", command:"Settings", glyph:"⚙"},
                {label:"Software", command:"Software Center", glyph:"▦"}
            ]
            delegate: ToolButton {
                width: 92
                height: 76
                display: AbstractButton.TextUnderIcon
                text: modelData.label
                icon.name: ""
                onClicked: shellController.command("launch " + modelData.command)
                background: Rectangle { color: parent.down ? "#334155" : (parent.hovered ? "#253246" : "transparent"); radius: 8; border.color: parent.hovered ? "#64748b" : "transparent" }
                contentItem: Column {
                    anchors.fill: parent
                    spacing: 5
                    Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.glyph; color: "white"; font.pixelSize: 28 }
                    Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.label; color: "white"; font.pixelSize: 11; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter }
                }
            }
        }
    }

    Rectangle {
        id: taskbar
        width: parent.width
        height: 54
        anchors.bottom: parent.bottom
        color: "#20242b"
        border.color: "#343947"
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 6
            ToolButton { text: "☷"; font.pixelSize: 23; ToolTip.text: "Start"; onClicked: start.visible = !start.visible }
            ToolButton { text: "⌕"; font.pixelSize: 22; ToolTip.text: "Search"; onClicked: search.visible = !search.visible }
            Item { Layout.fillWidth: true }
            Repeater {
                model: shellController.windows
                delegate: ToolButton {
                    Layout.maximumWidth: 180
                    text: modelData.title || "Window"
                    onClicked: shellController.command("activate " + index)
                }
            }
            Item { Layout.fillWidth: true }
            ToolButton { text: "⌁"; ToolTip.text: "Quick settings"; onClicked: quick.visible = !quick.visible }
            Column {
                spacing: 0
                Layout.alignment: Qt.AlignVCenter
                Label { text: Qt.formatDateTime(root.clockNow, "HH:mm"); color: "white"; horizontalAlignment: Text.AlignHCenter }
                Label { text: Qt.formatDateTime(root.clockNow, "ddd, dd MMM"); color: "white"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter }
            }
        }
    }

    Rectangle {
        id: start
        visible: false
        width: 720
        height: 520
        radius: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: taskbar.top
        anchors.bottomMargin: 8
        color: "#171b24"
        border.color: "#3b4352"
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 12
            Label { text: "WINUX11"; font.pixelSize: 28; font.bold: true; color: "white" }
            TextField {
                id: startSearch
                Layout.fillWidth: true
                placeholderText: "Search apps or Linux commands"
                onAccepted: { shellController.command("launch " + text); start.visible = false; text = "" }
            }
            Label { text: "Pinned"; color: "white"; font.bold: true; font.pixelSize: 17 }
            GridLayout {
                Layout.fillWidth: true
                columns: 5
                columnSpacing: 8
                rowSpacing: 8
                Button { text: "Files"; onClicked: shellController.command("launch Files") }
                Button { text: "Terminal"; onClicked: shellController.command("launch Terminal") }
                Button { text: "Browser"; onClicked: shellController.command("launch Browser") }
                Button { text: "Settings"; onClicked: shellController.command("launch Settings") }
                Button { text: "Task Manager"; onClicked: shellController.command("launch Task Manager") }
                Button { text: "Security"; onClicked: shellController.command("launch Security Center") }
                Button { text: "Software"; onClicked: shellController.command("launch Software Center") }
                Button { text: "Network"; onClicked: shellController.command("launch Network") }
                Button { text: "Downloader"; onClicked: shellController.command("launch Downloader") }
                Button { text: "Archive"; onClicked: shellController.command("launch Archive Manager") }
                Button { text: "Screenshot"; onClicked: shellController.command("launch Screenshot") }
                Button { text: "Calculator"; onClicked: shellController.command("launch Calculator") }
                Button { text: "Clock"; onClicked: shellController.command("launch Clock") }
                Button { text: "Calendar"; onClicked: shellController.command("launch Calendar") }
                Button { text: "Text Editor"; onClicked: shellController.command("launch Text Editor") }
                Button { text: "Photos"; onClicked: shellController.command("launch Photos") }
                Button { text: "Media Player"; onClicked: shellController.command("launch Media Player") }
                Button { text: "Music"; onClicked: shellController.command("launch Music") }
                Button { text: "Camera"; onClicked: shellController.command("launch Camera") }
                Button { text: "Voice Recorder"; onClicked: shellController.command("launch Voice Recorder") }
            }
            Item { Layout.fillHeight: true }
            RowLayout {
                Layout.fillWidth: true
                Label { text: "Linux apps supported through native executables"; color: "#cbd5e1"; Layout.fillWidth: true }
                Button { text: "Power"; onClicked: quick.visible = !quick.visible }
            }
        }
    }

    Rectangle {
        id: search
        visible: false
        width: 620
        height: 82
        radius: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 24
        color: "#171b24"
        border.color: "#3b4352"
        TextField {
            anchors.fill: parent
            anchors.margins: 10
            placeholderText: "Search installed apps or commands"
            onAccepted: { shellController.command("launch " + text); search.visible = false; text = "" }
        }
    }

    Rectangle {
        id: clipboard
        visible: false
        width: 460
        height: 300
        radius: 18
        anchors.right: parent.right
        anchors.bottom: taskbar.top
        anchors.rightMargin: 18
        anchors.bottomMargin: 10
        color: "#171b24"
        border.color: "#3b4352"
        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10
            Label { text: "Clipboard"; font.pixelSize: 22; color: "white" }
            TextArea {
                id: clipText
                width: parent.width
                height: 180
                text: shellController.clipboardText
                color: "white"
                wrapMode: TextEdit.Wrap
                background: Rectangle { color: "#0d1017"; radius: 10 }
            }
            Row {
                spacing: 8
                Button { text: "Copy"; onClicked: shellController.setClipboardText(clipText.text) }
                Button { text: "Refresh"; onClicked: clipText.text = shellController.clipboardText }
                Button { text: "Clear"; onClicked: { shellController.clearClipboard(); clipText.text = "" } }
            }
        }
    }

    Rectangle {
        id: quick
        visible: false
        width: 300
        height: 210
        radius: 18
        anchors.right: parent.right
        anchors.bottom: taskbar.top
        anchors.rightMargin: 18
        anchors.bottomMargin: 10
        color: "#171b24"
        border.color: "#3b4352"
        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 9
            Label { text: "Quick Settings"; color: "white"; font.pixelSize: 20 }
            Button { text: "Network"; onClicked: shellController.command("launch Network") }
            Button { text: "Sound"; onClicked: shellController.command("launch Sound Manager") }
            Button { text: "Display"; onClicked: shellController.command("launch Display Manager") }
            Label { text: "Ctrl+F1..F4 • Alt+Tab • Super+Arrows"; color: "white" }
        }
    }
}
