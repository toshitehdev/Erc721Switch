require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
require("hardhat-gas-reporter");

/** @type import('hardhat/config').HardhatUserConfig */

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const CMC_API_KEY = process.env.CMC_API_KEY;
const LOCAL_NODE_KEY = process.env.LOCAL_NODE_KEY;
const REMOTE_NODE_KEY = process.env.REMOTE_NODE_KEY;
const REMOTENODE_RPC = process.env.REMOTENODE_RPC;

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    localnode: {
      url: "http://127.0.0.1:8545/",
      accounts: [LOCAL_NODE_KEY],
      chainid: 31337,
    },
    remotenode: {
      url: REMOTENODE_RPC,
      accounts: [REMOTE_NODE_KEY],
      chainid: 1337,
    },
  },
  solidity: "0.8.17",
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: false,
    currency: "USD",
    coinmarketcap: CMC_API_KEY,
    token: "ETH",
  },
};
