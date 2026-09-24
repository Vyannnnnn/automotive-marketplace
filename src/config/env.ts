import "dotenv/config";

const port = Number(process.env.PORT ?? 3000);
const nodeEnv = process.env.NODE_ENV ?? "development";
const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error("DATABASE_URL is not configured");
}

export const env = {
  port,
  nodeEnv,
  databaseUrl,
} as const;
