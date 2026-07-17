import fs from "node:fs/promises";
import path from "node:path";
import { randomUUID } from "node:crypto";

const [requestedThemePath, expectedName] = process.argv.slice(2);
if (!requestedThemePath || !expectedName) {
  throw new Error("Usage: set-theme-profile.mjs /absolute/path/to/theme.json EXPECTED_NAME");
}

const themePath = path.resolve(requestedThemePath);
if (path.basename(themePath) !== "theme.json") {
  throw new Error("Display profile target must be a theme.json file.");
}

const theme = JSON.parse(await fs.readFile(themePath, "utf8"));
if (theme.name !== expectedName) {
  throw new Error(`Refusing to change unexpected theme “${theme.name || "unnamed"}”.`);
}

theme.appearance = "dark";
theme.art = {
  ...(theme.art && typeof theme.art === "object" ? theme.art : {}),
  safeArea: "none",
};

const temporary = `${themePath}.${process.pid}.${randomUUID()}.tmp`;
try {
  await fs.writeFile(temporary, `${JSON.stringify(theme, null, 2)}\n`, {
    mode: 0o600,
    flag: "wx",
  });
  await fs.rename(temporary, themePath);
  await fs.chmod(themePath, 0o600);
} finally {
  await fs.rm(temporary, { force: true }).catch(() => {});
}

console.log(`Display profile for “${expectedName}” locked to dark with the low-scrim safe area.`);
