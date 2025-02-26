import { GLib } from "astal";

const WALLPAPER_PATH = "~/Kantai/packages/ags/resources/Whirl.png";
const expand = (x: string) => {
  if (x.startsWith("~/")) {
    const homeDir = GLib.get_home_dir();
    return GLib.build_filenamev([homeDir, x.substring(2)]);
  }

  return GLib.canonicalize_filename(x, null);
};

interface WallpaperConfig {
  path: string;
  style: "zoom" | "stretch" | "center" | "scale";
}

export default {
  wallpaper: {
    path: expand(WALLPAPER_PATH),
    style: "stretch",
  } as WallpaperConfig,
};
