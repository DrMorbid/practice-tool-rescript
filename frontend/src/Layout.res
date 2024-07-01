%%raw(`import "./theme/layout.css"`)

%%raw(`
import { Inter } from "next/font/google";
`)

%%raw(`
const inter = Inter({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-inter"
});
`)

let fontInter: Next.Font.font = %raw(`
  inter
`)

@react.component
let default = (~children) => {
  <html className=fontInter.className>
    <body>
      <Main> {children} </Main>
    </body>
  </html>
}
