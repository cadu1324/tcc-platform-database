// Aplica migrations/ e seeds/ contra qualquer DATABASE_URL (local ou gerenciado).
//
// Uso:
//   DATABASE_URL=postgres://...  node scripts/migrate.js            migrations + seeds
//   node scripts/migrate.js --no-seed                               só migrations
//   node scripts/migrate.js --reset                                 dropa o schema public e recria tudo
//
// A DATABASE_URL pode vir do ambiente ou de um arquivo .env na raiz do repo.

import { readdirSync, readFileSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import pg from 'pg';

const ROOT = join(dirname(fileURLToPath(import.meta.url)), '..');

function loadDotEnv() {
  const envPath = join(ROOT, '.env');
  if (!existsSync(envPath)) return;
  for (const raw of readFileSync(envPath, 'utf8').split('\n')) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;
    const eq = line.indexOf('=');
    if (eq === -1) continue;
    const key = line.slice(0, eq).trim();
    let val = line.slice(eq + 1).trim();
    if ((val.startsWith('"') && val.endsWith('"')) || (val.startsWith("'") && val.endsWith("'"))) {
      val = val.slice(1, -1);
    }
    if (!(key in process.env)) process.env[key] = val;
  }
}

function sqlFilesIn(dir) {
  const full = join(ROOT, dir);
  if (!existsSync(full)) return [];
  return readdirSync(full)
    .filter((f) => f.endsWith('.sql'))
    .sort()
    .map((f) => ({ name: `${dir}/${f}`, path: join(full, f) }));
}

async function runFile(client, file) {
  process.stdout.write(`  -> ${file.name} ... `);
  const sql = readFileSync(file.path, 'utf8');
  await client.query('BEGIN');
  try {
    await client.query(sql);
    await client.query('COMMIT');
    console.log('ok');
  } catch (err) {
    await client.query('ROLLBACK');
    console.log('FALHOU');
    throw err;
  }
}

async function main() {
  loadDotEnv();

  const connectionString = process.env.DATABASE_URL;
  if (!connectionString) {
    console.error('ERRO: defina DATABASE_URL (no ambiente ou em .env).');
    process.exit(1);
  }

  const reset = process.argv.includes('--reset');
  const noSeed = process.argv.includes('--no-seed');

  const client = new pg.Client({
    connectionString,
    ssl: /\bsslmode=(require|verify|prefer)/.test(connectionString)
      ? { rejectUnauthorized: false }
      : undefined,
  });

  await client.connect();
  const { rows } = await client.query('select current_database() db, current_user usr');
  console.log(`Conectado a ${rows[0].db} como ${rows[0].usr}\n`);

  if (reset) {
    process.stdout.write('Resetando schema public ... ');
    await client.query('DROP SCHEMA public CASCADE; CREATE SCHEMA public;');
    console.log('ok\n');
  }

  console.log('Migrations:');
  for (const file of sqlFilesIn('migrations')) await runFile(client, file);

  if (!noSeed) {
    console.log('\nSeeds:');
    for (const file of sqlFilesIn('seeds')) await runFile(client, file);
  }

  await client.end();
  console.log('\nConcluido.');
}

main().catch((err) => {
  console.error('\n' + (err.stack || err.message));
  process.exit(1);
});
