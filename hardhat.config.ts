import { HardhatUserConfig, task } from "hardhat/config";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "@nomiclabs/hardhat-waffle";
import "hardhat-deploy";
import "@typechain/ethers-v5";
require("dotenv").config();

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: "0.8.7",
  networks: {
    hardhat: {
      forking: {
        url: process.env.ALCHEMY_MAINNET_RPC_URL + "",
      },
      gasPrice: 30,
      chainId: 1337,
    },
    // kovan: {
    //   url: process.env.TESTNET_RPC_URL,
    //   accounts: [process.env.PRIVATE_KEY+""],
    // }
  },
  namedAccounts: {
    deployer: 0,
  },
  paths: {
    deploy: "deploy",
    deployments: "deployments",
    imports: "imports",
  },
};
export default config;
