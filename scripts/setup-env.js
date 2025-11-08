const fs = require('fs');
const path = require('path');

const envPath = path.join(__dirname, '..', '.env.local');
const templatePath = path.join(__dirname, '..', 'ENV_TEMPLATE.txt');

if (fs.existsSync(envPath)) {
    process.exit(0);
}

// Read the template
const template = fs.readFileSync(templatePath, 'utf-8');

// Read the issuer keypair to get the private key
const keypairPath = path.join(__dirname, '..', 'issuer-keypair.json');
const keypairData = JSON.parse(fs.readFileSync(keypairPath, 'utf-8'));
const privateKeyBase64 = Buffer.from(keypairData.secretKey).toString('base64');

// Replace the private key in the template
const envContent = template.replace('ISSUER_PRIVATE_KEY=UZCwNMAViGRdpC/qDSPgKdevKgUBuUs7pc7oCEdp22mzFTJeq3/fh4vEeXaH/cdsF1URZOat3n8sHE1BefOdbQ==', `ISSUER_PRIVATE_KEY=${privateKeyBase64}`);

// Write .env.local
fs.writeFileSync(envPath, envContent);

