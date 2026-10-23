import { readdir } from "node:fs/promises"
import { fileURLToPath } from "node:url"
import { join } from "node:path"
import { spawnSync } from "node:child_process"

const root = fileURLToPath(new URL("../", import.meta.url))

async function collectTests(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  const groups = await Promise.all(entries.map(async (entry) => {
    const path = join(directory, entry.name)
    if (entry.isDirectory()) return collectTests(path)
    return entry.isFile() && entry.name.endsWith(".test.mjs") ? [path] : []
  }))
  return groups.flat()
}

const files = (await collectTests(join(root, "src"))).sort()
if (files.length === 0) throw new Error("No frontend tests found in src")
const result = spawnSync(process.execPath, ["--test", ...files], { stdio: "inherit", cwd: root })
if (result.error) throw result.error
process.exitCode = result.status ?? 1
