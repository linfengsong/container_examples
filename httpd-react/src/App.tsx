import {
  Footer,
  Hero,
  Navbar,
  Section,
  SectionItem,
  Type,
  from "@example/blueprint-react";
}

function App() {
  return (
    <Page
      cotentHead={
        <Navbar>
          <Type element="h1" size="x1">
            hellohelm
          </Type>
        </Navbar>
      }
      contentFoot={
        <Footer>
          <Footer.Section>
            <Type element="strong" size="sm">
              Lorem ipsum footer
            </Type>
          </Footer.Section>
        </Footer>
      }
    >
      <Section>
        <SectionItem>
          <Hero
            heading={
              <Type element="h1" marginBottom size="2x1">
                React Bluepring App
              </Type>
            }
            subheading={
              <Type element="h2" size="1g">
                Lorem ipsum
              </Type>
            }
          >
            <Type marginBottom>
              Lorem ipsum dolor sit amet consectetur adiposicing elit. Illlo
              ullam, ullam, ullam, hic, aut ratione maiores, voluptates
              consequuntur viate.
            </Type>
          </Hero>
        </SectionItem>
      </Section>
    </Page>
  );
}

export default App
