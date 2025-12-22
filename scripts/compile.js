import fs from "fs";
import path from "path";

const SOURCE_DIR = "data/treadmills";
const OUTPUT_FILE = "data/treadmills.json";

const files = fs.readdirSync(SOURCE_DIR)
    .filter(f => f.endsWith(".json"))
    .sort();

const treadmills = files.map(file => {
    const content = fs.readFileSync(path.join(SOURCE_DIR, file), "utf8");
    // Remove BOM if present
    const cleanContent = content.charCodeAt(0) === 0xFEFF ? content.slice(1) : content;
    return JSON.parse(cleanContent);
});

const output = {
    meta: {
        generatedAt: new Date().toISOString(),
        schemaVersion: "1.0.0"
    },
    treadmills
};

fs.writeFileSync(
    OUTPUT_FILE,
    JSON.stringify(output, null, 2) + "\n"
);
