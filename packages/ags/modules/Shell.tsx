import { Astal, Gdk, Gtk } from "astal/gtk3";
import Notch from "./Notch";
import Corner from "./CairoCorners";
import Workspaces from "./Workspaces";

export default (monitor: Gdk.Monitor) => {
  const { LEFT, TOP, RIGHT } = Astal.WindowAnchor;

  const HORIZONTAL = Gtk.Orientation.HORIZONTAL;
  const HEIGHT = 35;
  const START = Gtk.Align.START;
  const CENTER = Gtk.Align.CENTER;
  const END = Gtk.Align.END;
  const EXCLUSIVE = Astal.Exclusivity.EXCLUSIVE;
  const ANCHORS = LEFT | TOP | RIGHT;

  return (
    <window
      className="shell"
      gdkmonitor={monitor}
      exclusivity={EXCLUSIVE}
      anchor={ANCHORS}
      heightRequest={HEIGHT}
    >
      <centerbox orientation={HORIZONTAL} hexpand>
        {/* Left side */}
        <box
          className="leftModules"
          orientation={HORIZONTAL}
          halign={START}
          hexpand
        ></box>

        {/* Center */}
        <box
          className="centerModules"
          orientation={HORIZONTAL}
          halign={CENTER}
          hexpand
        >
          {Corner("topright", "15px")}
          <Notch />
          {Corner("topleft", "15px")}
        </box>

        {/* Right side */}
        <box
          className="rightModules"
          orientation={HORIZONTAL}
          halign={END}
          hexpand
        ></box>
      </centerbox>
    </window>
  );
};
