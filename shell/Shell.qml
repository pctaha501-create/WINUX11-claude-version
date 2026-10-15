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
    palette.button: "#a8212d40"
    palette.base: "#b8101724"
    palette.window: "#141c2b"
    palette.highlight: "#6678aaff"
    palette.mid: "#667b8da7"
    visible: true
    visibility: Window.FullScreen
    title: "WINUX11 Shell"
    color: "#090b10"
    flags: Qt.FramelessWindowHint
    property date clockNow: new Date()
    property bool showAllApps: false
    Timer { interval: 15000; running: true; repeat: true; onTriggered: root.clockNow = new Date() }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#111827" }
            GradientStop { position: 0.48; color: "#0a1020" }
            GradientStop { position: 1.0; color: "#080b12" }
        }
    }
    Rectangle {
        width: Math.min(root.width * 0.62, 900)
        height: width
        radius: width / 2
        y: root.height * 0.18
        id: ambientGlow
        property real drift: 0
        opacity: 0.22
        x: root.width * 0.42 + drift
        gradient: Gradient {
            GradientStop { position: 0; color: "#2563eb" }
            GradientStop { position: 1; color: "#111827" }
        }
        SequentialAnimation on drift {
            loops: Animation.Infinite
            NumberAnimation { to: 20; duration: 22000; easing.type: Easing.InOutSine }
            NumberAnimation { to: -20; duration: 22000; easing.type: Easing.InOutSine }
        }
    }
    Rectangle {
        width: Math.min(root.width * 0.32, 480)
        height: width
        radius: width / 2
        x: root.width * 0.58
        y: root.height * 0.40
        color: "#38bdf8"
        property real pulse: 0
        SequentialAnimation on pulse {
            loops: Animation.Infinite
            NumberAnimation { to: 0.045; duration: 9000; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0; duration: 9000; easing.type: Easing.InOutSine }
        }
        opacity: 0.10 + pulse
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -36
        spacing: 8
        opacity: 0.84
        Label {
            text: "Welcome to WINUX11"
            color: "#f4f8ff"
            font.pixelSize: Math.max(26, Math.min(38, root.width / 36))
            font.weight: Font.DemiBold
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: "A calmer space to create."
            color: "#b9c8df"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
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
                width: 94
                height: 78
                onClicked: shellController.command("launch " + modelData.command)
                background: Rectangle {
                    color: parent.down ? "#7760a5fa" : (parent.hovered ? "#554c87b8" : "#221d2a3c")
                    radius: 12
                    border.color: parent.hovered ? "#99b7d8f5" : "#33ffffff"
                    Behavior on color { ColorAnimation { duration: 140 } }
                    Behavior on border.color { ColorAnimation { duration: 140 } }
                }
                contentItem: Column {
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        width: 42; height: 42; radius: 13
                        anchors.horizontalCenter: parent.horizontalCenter
                        gradient: Gradient {
                            GradientStop { position: 0; color: modelData.command === "Files" ? "#77b7ff" : modelData.command === "Terminal" ? "#42c9a5" : modelData.command === "Browser" ? "#9a8bff" : modelData.command === "Settings" ? "#8da4bd" : "#4b8de8" }
                            GradientStop { position: 1; color: "#24364e" }
                        }
                        border.color: "#66ffffff"
                        Label { anchors.centerIn: parent; text: modelData.glyph; color: "white"; font.pixelSize: 24 }
                    }
                    Label { anchors.horizontalCenter: parent.horizontalCenter; text: modelData.label; color: "white"; font.pixelSize: 11; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter }
                }
            }
        }
    }

    Rectangle {
        id: taskbar
        height: 64
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "#b51b202a"
        border.color: "#66cbd5e1"
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: "#667b8ba3"
        }
        Row {
            anchors.centerIn: parent
            spacing: 5
            ToolButton {
                width: 46; height: 46
                contentItem: Grid {
                    columns: 2
                    spacing: 2
                    anchors.centerIn: parent
                    Rectangle { width: 9; height: 9; radius: 1; color: "#60a5fa" }
                    Rectangle { width: 9; height: 9; radius: 1; color: "#60a5fa" }
                    Rectangle { width: 9; height: 9; radius: 1; color: "#60a5fa" }
                    Rectangle { width: 9; height: 9; radius: 1; color: "#60a5fa" }
                }
                ToolTip.text: "Start"
                onClicked: { start.visible = !start.visible; search.visible = false }
                background: Rectangle { radius: 10; color: parent.down ? "#7760a5fa" : (parent.hovered ? "#554c87b8" : "#221d2a3c"); border.color: parent.hovered ? "#88b7d8f5" : "#22ffffff"; Behavior on color { ColorAnimation { duration: 140 } } }
            }
            ToolButton {
                width: 46; height: 46
                contentItem: Item {
                    anchors.fill: parent
                    Rectangle { x: 12; y: 10; width: 17; height: 17; radius: 9; color: "transparent"; border.color: "white"; border.width: 2 }
                    Rectangle { x: 27; y: 27; width: 8; height: 2; radius: 1; color: "white"; rotation: 45 }
                }
                ToolTip.text: "Search"
                onClicked: { search.visible = !search.visible; start.visible = false }
                background: Rectangle { radius: 10; color: parent.down ? "#7760a5fa" : (parent.hovered ? "#554c87b8" : "#221d2a3c"); border.color: parent.hovered ? "#88b7d8f5" : "#22ffffff"; Behavior on color { ColorAnimation { duration: 140 } } }
            }
            Rectangle { width: 1; height: 30; anchors.verticalCenter: parent.verticalCenter; color: "#52607080" }
            Repeater {
                model: [
                    {label:"Files", glyph:"▣", command:"Files"},
                    {label:"Browser", glyph:"◎", command:"Browser"},
                    {label:"Terminal", glyph:"›_", command:"Terminal"},
                    {label:"Settings", glyph:"⚙", command:"Settings"},
                    {label:"Task Manager", glyph:"▥", command:"Task Manager"}
                ]
                delegate: ToolButton {
                    width: 46; height: 46
                    text: modelData.glyph
                    font.pixelSize: 22
                    ToolTip.text: modelData.label
                    onClicked: shellController.command("launch " + modelData.command)
                    background: Rectangle {
                        radius: 10
                        color: parent.down ? "#5560a5fa" : (parent.hovered ? "#334c87b8" : "transparent")
                        Rectangle { visible: parent.parent.hovered; width: 18; height: 3; radius: 2; color: "#60a5fa"; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottom: parent.bottom; anchors.bottomMargin: 2 }
                    }
                }
            }
            Repeater {
                model: shellController.windows
                delegate: ToolButton {
                    width: 48; height: 46
                    text: "▰"
                    ToolTip.text: modelData.title || "Open window"
                    onClicked: shellController.command("activate " + index)
                    background: Rectangle { radius: 10; color: parent.hovered ? "#334c87b8" : "transparent" }
                }
            }
        }
        Row {
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            ToolButton {
                width: 42; height: 42
                text: "⌃"
                ToolTip.text: "System tray"
                onClicked: quick.visible = !quick.visible
                background: Rectangle { radius: 9; color: parent.hovered ? "#554c87b8" : "#221d2a3c"; border.color: "#33ffffff"; Behavior on color { ColorAnimation { duration: 140 } } }
            }
            ToolButton {
                width: 48; height: 42
                text: "◖"
                ToolTip.text: "Quick settings"
                onClicked: quick.visible = !quick.visible
                background: Rectangle { radius: 9; color: parent.hovered ? "#554c87b8" : "#221d2a3c"; border.color: "#33ffffff"; Behavior on color { ColorAnimation { duration: 140 } } }
            }
            ToolButton {
                height: 46
                width: 104
                onClicked: { quick.visible = !quick.visible; start.visible = false }
                background: Rectangle { radius: 9; color: parent.hovered ? "#554c87b8" : "#221d2a3c"; border.color: "#33ffffff"; Behavior on color { ColorAnimation { duration: 140 } } }
                contentItem: Column {
                    spacing: 0
                    anchors.centerIn: parent
                    Label { text: Qt.formatDateTime(root.clockNow, "HH:mm"); color: "white"; horizontalAlignment: Text.AlignHCenter; width: 104 }
                    Label { text: Qt.formatDateTime(root.clockNow, "dd/MM/yyyy"); color: "white"; font.pixelSize: 10; horizontalAlignment: Text.AlignHCenter; width: 104 }
                }
            }
        }
    }

    Rectangle {
        id: start
        visible: false
        width: Math.min(720, root.width - 40)
        height: Math.min(610, root.height - taskbar.height - 24)
        radius: 18
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: taskbar.top
        anchors.bottomMargin: 10
        color: "#bd1b2637"
        border.color: "#88b5c8df"
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 1; height: 1; radius: 1; color: "#55ffffff" }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14
            Label { text: "WINUX11"; font.pixelSize: 28; font.bold: true; color: "white" }
            TextField {
                id: startSearch
                Layout.fillWidth: true
                placeholderText: "Search apps, settings, or Linux commands"
                onAccepted: {
                    if (text.trim().length > 0) shellController.command("launch " + text.trim())
                    start.visible = false
                    text = ""
                }
                background: Rectangle { radius: 9; color: "#bb111722"; border.color: "#88a8c6e8" }
            }
            RowLayout {
                Layout.fillWidth: true
                Label { text: root.showAllApps ? "All apps" : "Pinned"; color: "white"; font.bold: true; font.pixelSize: 17; Layout.fillWidth: true }
                Button { text: root.showAllApps ? "Pinned  ‹" : "All apps  ›"; onClicked: root.showAllApps = !root.showAllApps }
            }
            GridLayout {
                id: pinnedApps
                visible: !root.showAllApps
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
                Button { text: "Calculator"; onClicked: shellController.command("launch Calculator") }
                Button { text: "Text Editor"; onClicked: shellController.command("launch Text Editor") }
            }
            Flickable {
                id: allApps
                visible: root.showAllApps
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: width
                contentHeight: appGrid.implicitHeight
                GridLayout {
                    id: appGrid
                    width: allApps.width
                    columns: 5
                    columnSpacing: 8
                    rowSpacing: 8
                    Button { text: "Files"; onClicked: shellController.command("launch Files") }
                    Button { text: "Terminal"; onClicked: shellController.command("launch Terminal") }
                    Button { text: "Browser"; onClicked: shellController.command("launch Browser") }
                    Button { text: "Settings"; onClicked: shellController.command("launch Settings") }
                    Button { text: "Task Manager"; onClicked: shellController.command("launch Task Manager") }
                    Button { text: "Security Center"; onClicked: shellController.command("launch Security Center") }
                    Button { text: "Software Center"; onClicked: shellController.command("launch Software Center") }
                    Button { text: "Network"; onClicked: shellController.command("launch Network") }
                    Button { text: "Downloader"; onClicked: shellController.command("launch Downloader") }
                    Button { text: "Archive Manager"; onClicked: shellController.command("launch Archive Manager") }
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
                    Button { text: "Disk Management"; onClicked: shellController.command("launch Disk Management") }
                    Button { text: "Update Manager"; onClicked: shellController.command("launch Update Manager") }
                    Button { text: "Startup Apps"; onClicked: shellController.command("launch Startup Apps") }
                    Button { text: "Printer Manager"; onClicked: shellController.command("launch Printer Manager") }
                    Button { text: "Display Manager"; onClicked: shellController.command("launch Display Manager") }
                    Button { text: "Sound Manager"; onClicked: shellController.command("launch Sound Manager") }
                    Button { text: "Privacy Center"; onClicked: shellController.command("launch Privacy Center") }
                    Button { text: "Bluetooth Manager"; onClicked: shellController.command("launch Bluetooth Manager") }
                    Button { text: "Wi-Fi Manager"; onClicked: shellController.command("launch Wi-Fi Manager") }
                }
            }
            Item { Layout.fillHeight: true }
            Rectangle { Layout.fillWidth: true; height: 1; color: "#334e5b70" }
            RowLayout {
                Layout.fillWidth: true
                Label { text: "●  Local user"; color: "white"; Layout.fillWidth: true }
                Button { text: "Power / session"; onClicked: quick.visible = !quick.visible }
            }
        }
    }

    Rectangle {
        id: search
        visible: false
        width: Math.min(620, root.width - 40)
        height: 94
        radius: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 24
        color: "#bd1b2637"
        border.color: "#88b5c8df"
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 1; height: 1; radius: 1; color: "#55ffffff" }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5
            TextField {
                id: quickSearch
                Layout.fillWidth: true
                placeholderText: "Search installed apps or Linux commands"
                onAccepted: {
                    if (text.trim().length > 0) shellController.command("launch " + text.trim())
                    search.visible = false
                    text = ""
                }
                background: Rectangle { radius: 9; color: "#bb111722"; border.color: "#88a8c6e8" }
            }
            Label { text: "Try: firefox  •  gimp  •  vlc  •  flatpak run org.mozilla.firefox"; color: "white"; font.pixelSize: 11 }
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
        color: "#bd1b2637"
        border.color: "#88b5c8df"
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 1; height: 1; radius: 1; color: "#55ffffff" }
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
                background: Rectangle { color: "#bb0d1017"; radius: 10; border.color: "#557d91ad" }
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
        width: 330
        height: 260
        radius: 18
        anchors.right: parent.right
        anchors.bottom: taskbar.top
        anchors.rightMargin: 18
        anchors.bottomMargin: 10
        color: "#bd1b2637"
        border.color: "#88b5c8df"
        Rectangle { anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top; anchors.margins: 1; height: 1; radius: 1; color: "#55ffffff" }
        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 10
            Label { text: "Quick Settings"; color: "white"; font.pixelSize: 21; font.bold: true }
            GridLayout {
                width: parent.width
                columns: 2
                rowSpacing: 8
                columnSpacing: 8
                Button { text: "Network"; Layout.fillWidth: true; onClicked: shellController.command("launch Network") }
                Button { text: "Sound"; Layout.fillWidth: true; onClicked: shellController.command("launch Sound Manager") }
                Button { text: "Display"; Layout.fillWidth: true; onClicked: shellController.command("launch Display Manager") }
                Button { text: "Bluetooth"; Layout.fillWidth: true; onClicked: shellController.command("launch Bluetooth Manager") }
            }
            Label { text: "System tools open using the installed Linux desktop utilities."; color: "white"; wrapMode: Text.Wrap; width: parent.width }
            Button { text: "Clipboard history"; onClicked: { clipboard.visible = !clipboard.visible; quick.visible = false } }
        }
    }
}
