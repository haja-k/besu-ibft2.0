require('dotenv').config();
const PrivateKeyProvider = require('@truffle/hdwallet-provider');
const privateKeys = [
  process.env.PRIVATE_KEY_1,
  process.env.PRIVATE_KEY_2,
  process.env.PRIVATE_KEY_3,
  process.env.PRIVATE_KEY_4
];

const nodeUrls = [
  'http://127.0.0.1:8545',
  'http://127.0.0.1:8546',
  'http://127.0.0.1:8547',
  'http://127.0.0.1:8548'
];

const networkConfigs = {};

nodeUrls.forEach((url, index) => {
  const privateKeyProvider = new PrivateKeyProvider(
    privateKeys,
    url,
    index,
    privateKeys.length
  );
  
  const networkName = `besu-${index}`;
  
  networkConfigs[networkName] = {
    provider: privateKeyProvider,
    network_id: '*',
    gas: "0x1ffffffffffffe",
    gasPrice: 0
  }
});

module.exports = {
  networks: networkConfigs
};
