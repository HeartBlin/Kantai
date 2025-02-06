import { exec } from "astal";
import { Astal, Gdk, Gtk } from "astal/gtk3";
import Corners from "./Corners";

function InfoBox() {
  const getInfo = () => {
    try {
      const hostname = exec("hostname").trim();
      const username = exec("whoami").trim();
      const prettyName = exec(`getent passwd ${username}`)
        .trim()
        .split(':')[4]
        ?.split(',')[0]
        ?.trim() || username;

      return `${hostname} @ ${prettyName}`;
    } catch (error) {
      return "Unknown@Unknown"
    }
  };

  return <box className="hostinfo">
    <label label={getInfo()} widthRequest={275} heightRequest={35}/>
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
