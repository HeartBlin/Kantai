import { Astal, Gdk } from "astal/gtk3";
import Config from "../../config";
import Cairo from "cairo";
import GdkPixbuf from "gi://GdkPixbuf?version=2.0";

export default (monitor: Gdk.Monitor) => {
  const geometry = monitor.get_geometry();
  const scale = monitor.get_scale_factor();

  return (
    <window
      className="wallpaper"
      decorated={false}
      exclusivity={Astal.Exclusivity.IGNORE}
      layer={0}
      appPaintable={true}
      widthRequest={geometry.width}
      heightRequest={geometry.height}
      gdkmonitor={monitor}
      setup={(wallpaper) => {
        wallpaper.connect("draw", (_, cr: Cairo.Context) => {
          try {
            const pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
              Config.wallpaper.path,
              geometry.width * scale,
              geometry.height * scale,
              Config.wallpaper.style !== "stretch"
            );

            cr.scale(1 / scale, 1 / scale);
            Gdk.cairo_set_source_pixbuf(cr, pixbuf, 0, 0);
            cr.paint();
          } catch (error) {
            console.error("Wallpaper Error:", error);
          }
        });
      }}
    />
  );
};
