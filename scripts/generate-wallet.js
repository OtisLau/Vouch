const { Keypair } = require('@solana/web3.js');
const fs = require('fs');
const path = require('path');

// Generate a new keypair
const keypair = Keypair.generate();

// Save keypair to file (backup)
const keypairData = {
    publicKey: keypair.publicKey.toBase58(),
    secretKey: Array.from(keypair.secretKey)
};

const outputPath = path.join(__dirname, '..', 'issuer-keypair.json');
fs.writeFileSync(
    outputPath,
    JSON.stringify(keypairData, null, 2)
);


