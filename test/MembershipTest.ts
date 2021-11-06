import { HardhatRuntimeEnvironment } from "hardhat/types";
import { expect } from "chai";
import { Signer } from "ethers";
import { ethers, deployments, getUnnamedAccounts, getNamedAccounts, hardhatArguments } from "hardhat";
import { MembershipCard } from "../typechain";

describe("Membership Contract", function () {
  let accounts: Signer[];
  let hre: HardhatRuntimeEnvironment;
  let membership: MembershipCard;

  // Before each
  this.beforeAll(async function () {
    accounts = await ethers.getSigners();
    await deployments.fixture(["MembershipCard"]);
    membership = <MembershipCard>await ethers.getContract("MembershipCard");
  });

  it("Should have the tier names set", async function () {
    const tierName = await membership.tierNames(4);
    expect(tierName).to.equal("Diamond");
  });

  it("Should return the array of tiers", async function () {
    const tierSize = await membership.getTiers();
    expect(tierSize.names.length).to.equal(5);
    expect(tierSize.thresholds.length).to.equal(5);
  });
});
