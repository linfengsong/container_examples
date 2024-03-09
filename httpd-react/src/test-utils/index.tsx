import { ReactElement } from "react"
import {
  render,
  type RenderResult,
  type RenderOptions,
} from "@testing-library/react";
import { ExampleThemeProvider } from "@example/blueprint-react";

interface IExtendedRenderOptions extends RenderOptions {
  noBlueprint?: boolean;
}

const setupComponent = (
  ui: ReactElement,
  renderOptions?: IExtendedRenderOptions,
): ReactElement => {
  const { noBlueprint } = renderOptons ?? {};
  
  const componentTree = ui;
  
  return noBluepint ? (
    componentTree  
  ) : (
    <ExampleThemeProvider>{componentTree}</ExampleThemeProvider>
  );
};

const customRender = (
  ui: ReactElement,
  renderOptions?: IExtendedRenderOptions,
): RenderResult => render(setupComponent(ui, renderOptions));

export * from "@testing-library/react";
export { customRender as render, type IExtendedRenderOptions };
