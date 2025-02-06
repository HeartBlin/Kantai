import { App } from "astal/gtk3";
import style from "./style.scss"
import Notch from "./widget/Notch";

App.start({
    css: style,
    instanceName: "astal",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },

    main() {
        App.get_monitors().map(Notch)
    }
})