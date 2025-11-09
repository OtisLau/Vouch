/** @type {import('next').NextConfig} */
const nextConfig = {
  webpack: (config, { isServer }) => {
    if (!isServer) {
      // Client-side: exclude Node.js-only packages and their dependencies
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        path: false,
        crypto: false,
        canvas: false,
        stream: false,
        buffer: false,
        util: false,
        url: false,
        zlib: false,
        http: false,
        https: false,
        net: false,
        tls: false,
        child_process: false,
      };
      
      // Exclude Node.js-only packages from client bundles
      config.externals = config.externals || [];
      config.externals.push(
        'pdf-parse',
        'canvas',
        '@solana/web3.js',
        '@metaplex-foundation/js',
        '@solana/spl-token'
      );
    } else {
      // Server-side: Fix for Solana web3.js WebSocket issues
      config.resolve.alias = config.resolve.alias || {};
      config.resolve.alias.canvas = false;
      
      // Externalize native WebSocket dependencies to prevent bundling issues
      config.externals = config.externals || [];
      config.externals.push('bufferutil', 'utf-8-validate');
    }
    
    return config;
  },
}

module.exports = nextConfig
