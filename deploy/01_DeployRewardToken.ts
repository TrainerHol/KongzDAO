import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/dist/types";

const func: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deploy } = deployments;

  console.log({ live: hre.network.live });

  const { deployer } = await getNamedAccounts();
  /* Contract Parameters
   *  Replace the empty values with the ones you want when deploying!
   *  Card tiers and value for thresholds can be changed, too.
   */
  const _tokenName = "KongzDAO Reward Token";
  const _tokenSymbol = "KDRT";
  const _multisig = deployer; // Multisig address
  const _membershipContract = deployments.get("MembershipCard");

  await deploy("RewardToken", {
    contract: "RewardToken",
    from: deployer,
    args: [_tokenName, _tokenSymbol, _multisig, _membershipContract],
    log: true,
  });
};

export default func;
func.id = "deploy_rewardtoken";
func.tags = ["RewardToken"];
