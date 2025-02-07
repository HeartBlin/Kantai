import { exec } from "astal";
import { Gtk } from "astal/gtk3";

export default () => {
  const getInfo = () => {
    try {
      const hostname = exec("hostname").trim();
      const username = exec("whoami").trim();
      const prettyName =
        exec(`getent passwd ${username}`)
          .trim()
          .split(":")[4]
          ?.split(",")[0]
          ?.trim() || username;

      return `${hostname} @ ${prettyName}`;
    } catch (error) {
      return "Unknown@Unknown";
    }
  };

  return (
    <box halign={Gtk.Align.CENTER} className="notch">
      <label label={getInfo()} className="notch_label" widthRequest={275} />
    </box>
  );
};
