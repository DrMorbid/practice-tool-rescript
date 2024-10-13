const fs = require("fs");
const cp = require("child_process");
const path = require("path");
const allLocales = require("../src/i18n/locales.json");

const defaultLocale = "en";
const locales = JSON.parse(JSON.stringify(allLocales));

const cwd = process.cwd();
const src = path.join(cwd, "src");
const bin = process.platform.toLowerCase().startsWith("win")
  ? path.join(cwd, "scripts", "rescript-react-intl-extractor.exe")
  : path.join(cwd, "node_modules", ".bin", "rescript-react-intl-extractor");

console.log(`Extracting messages...`);
const extracted = JSON.parse(cp.execSync(`${bin} ${src}`));
console.log(`Extracting messages... done.`);

for (const locale of locales) {
  console.log(`Updating ${locale} translation...`);
  const file = path.join(src, "i18n", "_locales", locale, "messages.json");

  let content;
  try {
    content = JSON.parse(fs.readFileSync(file));
  } catch (error) {
    if (error.code === "ENOENT") {
      console.log(`Translation for ${locale} wasn't found. Creating new one.`);
      content = [];
    } else {
      throw error;
    }
  }

  const messages = extracted.reduce((acc, msg) => {
    const valueFromFile = content[msg.id];

    if (locale === defaultLocale) {
      acc[msg.id] = {
        message: msg.defaultMessage,
        description: msg.description,
      };
    } else {
      if (valueFromFile && Object.keys(valueFromFile).length > 0) {
        acc[msg.id] = { ...valueFromFile, description: msg.description };
      } else {
        acc[msg.id] = { message: "", description: msg.description };
      }
    }

    return acc;
  }, {});

  fs.writeFileSync(file, JSON.stringify(messages, null, 4) + "\n");
  console.log(`Updating ${locale} translation... done.`);
}
