// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./MembershipCard.sol";

contract RewardToken is ERC20, Ownable {
    MembershipCard membershipContract;
    uint256 public currentBalance;
    // Card ID to reward token balance
    mapping(uint256 => uint256) cardBalances;
    // Reward Snapshots
    mapping(uint256 => uint256) rewardSnapshots;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 initialSupply,
        address multisig,
        address _membershipContract
    ) ERC20(tokenName, tokenSymbol) {
        _mint(multisig, initialSupply * 10**decimals());
        transferOwnership(multisig);
        membershipContract = MembershipCard(_membershipContract);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function mintAndDistribute(uint256 amount) public onlyOwner {
        mint(address(this), amount);
        currentBalance += amount;
    }
}
