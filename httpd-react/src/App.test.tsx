import { describe, it } from "vitest";
import App from "@site/src/App"
import { render, screen } from "@test-utils";

describe("App", () => {
  it("renders Navbar test", () => {
    render(<App />);
    
    const headingElement = screen.getByText("hellohelm")
    expect(headingElement).toBeInTheDocument();
  })
})