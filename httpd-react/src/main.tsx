import React from "react";
import ReactDOM from "react-dom/client";
import { ExampleThemeProvider } from "@example/blueprint-react";
import App from "@site/src/App";
import "@site/src/index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <ExampleThemeProvider>
      <App />
    </ExampleThemeProvider>
  </React.StrictMode>
);
