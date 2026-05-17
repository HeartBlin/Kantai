import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Scope {
    id: root

    property bool shouldShowOsd: false

    Connections {
        target: Hyprland
        function onFocusedWorkspaceChanged() {
            root.shouldShowOsd = true
            hideTimer.restart()
        }
    }

    Timer {
        id: hideTimer
        interval: 1250
        onTriggered: root.shouldShowOsd = false
    }

    LazyLoader {
        active: root.shouldShowOsd

        PanelWindow {
            WlrLayershell.namespace: "kantai-workspaces"

            anchors.top: true
            margins.top: screen.height / 20
            exclusiveZone: 0

            implicitWidth: workspaceRow.width + 8
            implicitHeight: 48
            color: "transparent"

            mask: Region { }

            Rectangle {
                anchors.fill: parent
                radius: 15
                color: "#191919"

                Row {
                    id: workspaceRow
                    anchors.centerIn: parent
                    spacing: 5

                    Repeater {
                        model: Hyprland.workspaces.values

                        Rectangle {
                            id: workspaceBtn

                            property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id

                            width: 40
                            height: 40
                            radius: 10

                            scale: 1.0
                            onIsActiveChanged: {
                                if (isActive) activePulse.restart()
                            }

                            color: isActive ? "#78bfff" : "#191919"
                            Text {
                                anchors.centerIn: parent

                                text: modelData.id
                                color: isActive ? "#002e4d" : "#FFFFFF"
                                font { pixelSize: 14; bold: true }
                            }
                        }
                    }
                }
            }
        }
    }
}
