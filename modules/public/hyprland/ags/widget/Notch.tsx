import { bind, exec, GLib, Variable } from "astal";
import { Astal, Gdk, Gtk } from "astal/gtk3";
import Corners from "./Corners";
import Hyprland from "gi://AstalHyprland";
function Time({ format = "%H:%M" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!
  );

  return (
    <label
      className="Time"
      onDestroy={() => time.drop()}
      label={time()}
      widthRequest={300}
    />
  );
}

function InfoBox() {
  const getInfo = () => {
    try {
      const hostname = exec("hostname").trim();
      const username = exec("whoami").trim();
      return `${hostname}@${username}`;
    } catch (error) {
      return "Unknown@Unknown"
    }
  };

  return <box className="hostinfo">
    <label label={getInfo()} widthRequest={300}/>
  </box>
}

export default function Notch(monitor: Gdk.Monitor) {
  return (
    <window
      className="Notch"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={Astal.WindowAnchor.TOP}
    >
      <centerbox>
        {Corners("topright")}
        <box halign={Gtk.Align.CENTER} className="container-box">
          <InfoBox />
        </box>
        {Corners("topleft")}
      </centerbox>
    </window>
  );
}
