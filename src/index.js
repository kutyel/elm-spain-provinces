import { Elm } from "./Main.elm";
import { inject } from "@vercel/analytics";

inject();

Elm.Main.init({ node: document.getElementById("root") });
