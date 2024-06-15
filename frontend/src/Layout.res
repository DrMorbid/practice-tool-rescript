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

let fontInter: Next.font = %raw(`
  inter
`)

@react.component
let default = (~children) => {
  <html lang="cs" className=fontInter.className>
    <body>
      <Main> {children} </Main>
    </body>
  </html>
}
