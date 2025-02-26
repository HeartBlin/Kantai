import { App } from "astal/gtk3";
import createShell from "./modules/Bar/Shell";
import createWallpaper from "./modules/Desktop/Wallpaper";
import style from "./style.scss";

App.start({
  instanceName: "astal",
  css: style,
  main: () => {
    App.get_monitors().forEach((monitor) => {
      createWallpaper(monitor);
      createShell(monitor);
    });
  },
});
