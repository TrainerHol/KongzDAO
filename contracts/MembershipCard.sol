// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MembershipCard is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public intervals;
    // Distribution
    mapping(uint256 => uint256) public cardStakes;
    CardTier[] public tiers;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        address multisig,
        string[] memory _tierNames,
        uint256[] memory _thresholds
    ) ERC721(_tokenName, _tokenSymbol) {
        transferOwnership(multisig);
        for (uint256 index = 0; index < _tierNames.length; index++) {
            tiers[index] = CardTier(_tierNames[index], _thresholds[index]);
        }
    }

    function safeMint(address to) public payable {
        _safeMint(to, _tokenIdCounter.current());
        _tokenIdCounter.increment();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

struct CardTier {
    string name;
    uint256 threshold;
}
