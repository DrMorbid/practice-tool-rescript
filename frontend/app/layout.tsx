import type { Metadata, Viewport } from "next";
import type { ReactNode } from "react";

const APP_NAME = "Practice Tool";
const APP_DESCRIPTION = "Tool to help you practice what needs to be practiced";

export const metadata: Metadata = {
  applicationName: APP_NAME,
  title: {
    default: APP_NAME,
    template: "%s - Practice Tool",
  },
  description: APP_DESCRIPTION,
  manifest: "/manifest.json",
  appleWebApp: {
    capable: true,
    statusBarStyle: "default",
    title: APP_NAME,
  },
  formatDetection: {
    telephone: false,
  },
  icons: {
    shortcut: "/favicon.ico",
    apple: [{ url: "/icons/maskable_icon_x192.png", sizes: "192x192" }],
  },
};

export const viewport: Viewport = {
  themeColor: "#FFFFFF",
};

export { default } from "../src/Layout.res.js";