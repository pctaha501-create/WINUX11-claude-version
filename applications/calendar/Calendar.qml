import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ApplicationWindow {
    visible: true
    width: 760
    height: 620
    title: "WINUX11 Calendar"
    color: "#090b10"
    palette.windowText: "white"
    palette.text: "white"
    palette.buttonText: "white"
    palette.brightText: "white"
    palette.highlightedText: "white"
    palette.placeholderText: "white"
    property date shownMonth: new Date()
    property date selectedDate: new Date()
    property var cells: []
    function rebuild() {
        var first = new Date(shownMonth.getFullYear(), shownMonth.getMonth(), 1)
        var start = (first.getDay() + 6) % 7
        var count = new Date(shownMonth.getFullYear(), shownMonth.getMonth() + 1, 0).getDate()
        var out = []
        for (var i = 0; i < 42; ++i) {
            var n = i - start + 1
            var d = new Date(shownMonth.getFullYear(), shownMonth.getMonth(), n)
            out.push({day: d.getDate(), date: d, current: n >= 1 && n <= count})
        }
        cells = out
    }
    function monthTitle() { return Qt.formatDateTime(shownMonth, "MMMM yyyy") }
    function isToday(d) {
        var t = new Date()
        return d.getFullYear() === t.getFullYear() && d.getMonth() === t.getMonth() && d.getDate() === t.getDate()
    }
    function isSelected(d) {
        return d.getFullYear() === selectedDate.getFullYear() && d.getMonth() === selectedDate.getMonth() && d.getDate() === selectedDate.getDate()
    }
    Component.onCompleted: rebuild()
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14
        RowLayout {
            Layout.fillWidth: true
            Button { text: "‹"; onClicked: { shownMonth = new Date(shownMonth.getFullYear(), shownMonth.getMonth() - 1, 1); rebuild() } }
            Label { Layout.fillWidth: true; text: monthTitle(); horizontalAlignment: Text.AlignHCenter; font.pixelSize: 30; color: "white" }
            Button { text: "›"; onClicked: { shownMonth = new Date(shownMonth.getFullYear(), shownMonth.getMonth() + 1, 1); rebuild() } }
            Button { text: "Today"; onClicked: { shownMonth = new Date(); selectedDate = new Date(); rebuild() } }
        }
        GridLayout {
            columns: 7
            Layout.fillWidth: true
            Repeater {
                model: ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                delegate: Label { Layout.fillWidth: true; text: modelData; horizontalAlignment: Text.AlignHCenter; color: "white"; font.bold: true }
            }
        }
        GridLayout {
            columns: 7
            rows: 6
            Layout.fillWidth: true
            Layout.fillHeight: true
            columnSpacing: 6
            rowSpacing: 6
            Repeater {
                model: cells
                delegate: Button {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: String(modelData.day)
                    enabled: modelData.current
                    opacity: modelData.current ? 1 : 0.35
                    highlighted: isToday(modelData.date)
                    checkable: true
                    checked: isSelected(modelData.date)
                    onClicked: selectedDate = modelData.date
                }
            }
        }
        Label {
            Layout.fillWidth: true
            text: "Selected: " + Qt.formatDateTime(selectedDate, "dddd, dd MMMM yyyy")
            color: "white"
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
