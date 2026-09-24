import fs from "node:fs/promises";
import path from "node:path";

import { pool } from "../config/database.js";

const migrationsPath = path.join(__dirname, "migrations");

async function migrate(): Promise<void> {
  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    await client.query(`
      CREATE TABLE IF NOT EXISTS schema_migrations (
        id SERIAL PRIMARY KEY,
        filename VARCHAR(255) NOT NULL UNIQUE,
        executed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
      );
    `);

    const files = (await fs.readdir(migrationsPath))
      .filter((file) => file.endsWith(".sql"))
      .sort();

    for (const file of files) {
      const result = await client.query(
        `
          SELECT 1
          FROM schema_migrations
          WHERE filename = $1
        `,
        [file],
      );

      if (result.rowCount && result.rowCount > 0) {
        console.log(`Skipping ${file}`);
        continue;
      }

      const filePath = path.join(migrationsPath, file);
      const sql = await fs.readFile(filePath, "utf8");

      console.log(`Running ${file}`);

      await client.query(sql);

      await client.query(
        `
          INSERT INTO schema_migrations (filename)
          VALUES ($1)
        `,
        [file],
      );
    }

    await client.query("COMMIT");

    console.log("Migrations completed successfully.");
  } catch (error) {
    await client.query("ROLLBACK");

    console.error("Migration failed:", error);

    process.exitCode = 1;
  } finally {
    client.release();
    await pool.end();
  }
}

migrate();
