import { App, Gtk } from "astal/gtk3";
import createShell from "./modules/Shell";
import style from "./style.scss";

App.start({
  instanceName: "astal",
  css: style,
  main: () => {
    App.get_monitors().forEach((monitor) => {
      const shell = createShell(monitor);

      shell.connect("size-allocate", (widget: Gtk.Widget) => {
        const height = widget.get_allocation().height;
        const monitorId = monitor.display.get_name();
        console.log(`Actual bar height for ${monitorId}: ${height}px`);
      });
    });
  },
});
