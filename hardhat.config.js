require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require("@nomiclabs/hardhat-etherscan");
const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL1;
const GOERLI_PVT_KEY= process.env.GOERLI_PVT_KEY1;


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${GOERLI_RPC_URL}`,
      accounts: [GOERLI_PVT_KEY]
    }
  },etherscan: {
    apiKey: process.env.EthApiKey
  },
  
  
};
