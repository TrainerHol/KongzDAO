import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { parseEther, parseUnits } from "@ethersproject/units";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  console.log({ live: hre.network.live });

  /* Contract Parameters
   *  Replace the empty values with the ones you want when deploying!
   *  Card tiers and value for thresholds can be changed, too.
   */
  const _bananaContract = ""; // The address of the banana ERC-20 contract
  const _tokenName = "KongzDAO Membership Card";
  const _tokenSymbol = "KDMC";
  const _multisig = ""; // Multisig address
  // Tier names of the cards, must be the same number as the thresholds!
  const _tierNames = ["Bronze", "Silver", "Gold", "Platinum", "Diamond"];
  const _thresholds = [
    parseUnits("0.1"), // Bronze
    parseUnits("1.0"), // Silver
    parseUnits("3.0"), // Gold
    parseUnits("10.0"), // Platinum
    parseUnits("30.0"), //Diamond
  ];
  const _imageAPI = ""; // URL of the base image API
  const _animationAPI = ""; // URL of the base animation API

  const { deployer } = await getNamedAccounts();

  await deploy("MembershipCard", {
    from: deployer,
    args: [_bananaContract, _tokenName, _tokenSymbol, _multisig, _tierNames, _thresholds, _imageAPI, _animationAPI],
    log: true,
  });
};

export default func;
func.tags = ["MembershipCard"];
