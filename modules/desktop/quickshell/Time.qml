import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Text {
  id: clock

  property color clockColor: "#FFFFFF"
  property var format: "yyyy-MM-dd HH:mm:ss"

  topPadding: 1
  text: Qt.formatDateTime(new Date(), format)
  color: clockColor
  font { pixelSize: 13; family: "monospace"; }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: clock.text = Qt.formatDateTime(new Date(), clock.format)
  }
}
