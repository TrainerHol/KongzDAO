// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface Banana is IERC20 {
    function getTotalClaimable(address _user) external view returns (uint256);
}
