import { app } from "./app.js";
import { env } from "./config/env.js";
import { checkDatabaseConnection } from "./database/health.js";

async function bootstrap(): Promise<void> {
  await checkDatabaseConnection();

  app.listen(env.port, () => {
    console.log(`API running on http://localhost:${env.port}`);
  });
}

bootstrap().catch((error: unknown) => {
  console.error("Failed to start server:", error);
  process.exit(1);
});
