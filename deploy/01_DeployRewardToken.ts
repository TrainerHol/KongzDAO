import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/dist/types";
import { parseEther, parseUnits } from "@ethersproject/units";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  //console.log({ live: hre.network.live });

  const { deployer } = await getNamedAccounts();
  /* Contract Parameters
   *  Replace the empty values with the ones you want when deploying!
   *  Card tiers and value for thresholds can be changed, too.
   */
  const _tokenName = "KongzDAO Reward Token";
  const _tokenSymbol = "KDRT";
  const _initialSupply = parseEther("100000");
  const _multisig = deployer; // Multisig address
  const _membershipContract = await deployments.get("MembershipCard");

  await deploy("RewardToken", {
    contract: "RewardToken",
    from: deployer,
    args: [_tokenName, _tokenSymbol, _initialSupply, _multisig, _membershipContract.address],
    log: false,
  });
};

export default func;
func.id = "deploy_rewardtoken";
func.tags = ["RewardToken"];
