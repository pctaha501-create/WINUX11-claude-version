import QtQuick
import QtQuick.Controls

ApplicationWindow {
    palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"
    visible: true
    width: 720
    height: 340
    title: "WINUX11 Voice Recorder"
    color: "#090b10"
    Column {
        anchors.centerIn: parent
        spacing: 12
        TextField { id: path; width: 620; text: "record.wav"; color: "white" }
        Button {
            text: media.recording ? "Stop" : "Record"
            onClicked: media.recording ? media.stopRecording() : media.startRecording(path.text)
        }
        Label { text: media.recording ? "Recording…" : "Ready"; color: "white" }
    }
}
