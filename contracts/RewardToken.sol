// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 initialSupply,
        address multisig
    ) ERC20(tokenName, tokenSymbol) {
        _mint(multisig, initialSupply * 10**decimals());
        transferOwnership(multisig);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
