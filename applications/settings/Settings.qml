import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    palette.windowText: "white"
    palette.text: "white"
    palette.buttonText: "white"
    palette.brightText: "white"
    palette.highlightedText: "white"
    palette.placeholderText: "white"
    visible: true
    width: 1100
    height: 760
    title: "WINUX11 Settings"
    color: "#090b10"

    property int selectedPage: 0
    property var info: systemInfo.snapshot()
    property string statusText: "Ready"

    function json(value) {
        return JSON.stringify(value, null, 2)
    }

    function refresh() {
        info = systemInfo.snapshot()
        statusText = "Refreshed"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 22
        spacing: 14

        Label {
            text: "WINUX11 Settings"
            color: "white"
            font.pixelSize: 34
        }

        GridLayout {
            columns: 5
            rowSpacing: 8
            columnSpacing: 8
            Layout.fillWidth: true

            Repeater {
                model: ["System", "Network", "Audio", "Storage", "Users", "Display", "Security", "Updates", "Printers", "Startup", "Privacy"]
                delegate: Button {
                    required property string modelData
                    required property int index
                    text: modelData
                    Layout.fillWidth: true
                    onClicked: selectedPage = index
                }
            }
        }

        StackLayout {
            id: pages
            currentIndex: selectedPage
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                TextArea {
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: json(info)
                    wrapMode: TextEdit.Wrap
                }
            }

            ColumnLayout {
                spacing: 10
                Label { text: json(systemControl.networkState()); color: "white" }
                RowLayout {
                    Button {
                        text: "Enable"
                        onClicked: statusText = systemControl.setNetworkEnabled(true) ? "Network enabled" : "Network change failed"
                    }
                    Button {
                        text: "Disable"
                        onClicked: statusText = systemControl.setNetworkEnabled(false) ? "Network disabled" : "Network change failed"
                    }
                    Button {
                        text: "Refresh"
                        onClicked: statusText = json(systemControl.networkState())
                    }
                }
            }

            ColumnLayout {
                spacing: 10
                Label { text: json(systemControl.audioState()); color: "white" }
                Slider { id: volume; from: 0; to: 100; value: 50; Layout.fillWidth: true }
                Button {
                    text: "Apply Volume"
                    onClicked: statusText = systemControl.setAudioVolume(volume.value) ? "Volume applied" : "Volume change failed"
                }
            }

            ScrollView {
                TextArea {
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: json(systemControl.storageState())
                    wrapMode: TextEdit.Wrap
                }
            }

            ColumnLayout {
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: systemControl.users()
                    delegate: Label {
                        required property var modelData
                        text: modelData.name + "  UID " + modelData.uid + "  " + modelData.home
                        color: "white"
                        height: 34
                    }
                }
                Button { text: "Refresh Users"; onClicked: pages.currentIndex = 4 }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: systemTools.query("display")
                    wrapMode: TextEdit.Wrap
                }
                Button { text: "Refresh Display Info"; onClicked: statusText = systemTools.query("display") }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: json(systemControl.firewallState())
                    wrapMode: TextEdit.Wrap
                }
                Button {
                    text: "Refresh Firewall"
                    onClicked: statusText = json(systemControl.firewallState())
                }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: json(systemControl.packageUpdates())
                    wrapMode: TextEdit.Wrap
                }
                Button {
                    text: "Check Updates"
                    onClicked: statusText = json(systemControl.packageUpdates())
                }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: systemTools.query("printers")
                    wrapMode: TextEdit.Wrap
                }
                Button { text: "Refresh Printers"; onClicked: statusText = systemTools.query("printers") }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: systemTools.query("startup")
                    wrapMode: TextEdit.Wrap
                }
                Button { text: "Refresh Startup"; onClicked: statusText = systemTools.query("startup") }
            }

            ColumnLayout {
                TextArea {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    readOnly: true
                    color: "white"
                    background: Rectangle { color: "#11151d"; radius: 14 }
                    text: systemTools.query("privacy")
                    wrapMode: TextEdit.Wrap
                }
                Button { text: "Refresh Privacy"; onClicked: statusText = systemTools.query("privacy") }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Button { text: "Refresh System"; onClicked: refresh() }
            Item { Layout.fillWidth: true }
            Label { text: statusText; color: "white" }
        }
    }
}
