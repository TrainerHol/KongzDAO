// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Interfaces/Banana.sol";
import "./Helpers/StructureHelpers.sol";

contract MembershipCard is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using StructureHelpers for string;
    using StructureHelpers for uint256;

    Counters.Counter private _tokenIdCounter;
    uint256 public constant interval = 1 * 10**17;
    Banana bananaContract;
    // Distribution
    mapping(uint256 => uint256) public cardBalances;
    mapping(uint256 => uint256) rewardSnapshots;
    uint256 currentBalances;
    uint256 bananaRewards;
    uint256 bananaChange;
    CardTier[] public tiers;
    // Metadata
    string imageAPI;
    string animationAPI;
    string constant description = "Kongz DAO Membership Card";
    string constant external_url = "https://www.kongzdao.com";

    constructor(
        address _bananaContract,
        string memory _tokenName,
        string memory _tokenSymbol,
        address multisig,
        string[] memory _tierNames,
        uint256[] memory _thresholds,
        string memory _imageAPI,
        string memory _animationAPI
    ) ERC721(_tokenName, _tokenSymbol) {
        transferOwnership(multisig);
        setTiers(_tierNames, _thresholds);
        bananaContract = Banana(_bananaContract);
        imageAPI = _imageAPI;
        animationAPI = _animationAPI;
    }

    function setTiers(string[] memory _tierNames, uint256[] memory _thresholds)
        internal
    {
        for (uint256 index = 0; index < _tierNames.length; index++) {
            tiers[index] = CardTier(_tierNames[index], _thresholds[index]);
        }
    }

    function getCardPoints(uint256 _id) public view returns (uint256 val) {
        val = cardBalances[_id] / interval;
    }

    function safeMint(address to) public payable {
        require(msg.value >= interval, "Low val");
        _safeMint(to, _tokenIdCounter.current());
        uint256 id = _tokenIdCounter.current();
        cardBalances[id] = msg.value;
        currentBalances += msg.value / interval;
        _tokenIdCounter.increment();
    }

    function increaseCardBalance(uint256 _id) public payable {
        require(msg.value >= interval, "Low val");
        cardBalances[_id] += msg.value;
        currentBalances += msg.value / interval;
    }

    function distributeBanana(uint256 _amount) public {
        require(_amount > 0 && currentBalances > 0);
        _amount += bananaChange;
        bananaRewards += _amount / currentBalances;
        bananaChange = _amount % currentBalances;
    }

    function claimBanana(uint256 _cardId) public {
        require(msg.sender == ownerOf(_cardId), "NotOwner");
        uint256 unclaimedBananas = getCardPoints(_cardId) *
            (bananaRewards - rewardSnapshots[_cardId]);
        if (unclaimedBananas > 0) {
            rewardSnapshots[_cardId] = bananaRewards;
            bananaContract.transfer(msg.sender, unclaimedBananas);
        }
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

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        // TODO: Dynamic metadata
        string memory metadata = "{\n";
        string memory nameProp = string(
            abi.encodePacked("KDMC #", tokenId.toString())
        );
        metadata.propertyConcat("name", nameProp);
        metadata.propertyConcat("description", description);
        string memory imageProp = string(
            abi.encodePacked(imageAPI, tokenId.toString())
        );
        metadata.propertyConcat("image", imageProp);
        string memory animProp = string(
            abi.encodePacked(animationAPI, tokenId.toString())
        );
        metadata.propertyConcat("animation_url", animProp);
        string memory attributes = '{ "attributes": [ {';
        attributes.propertyConcat("trait_type", "Points");
        attributes.propertyConcat("value", getCardPoints(tokenId).toString());
        attributes = string(abi.encodePacked(attributes, "} ] }\n"));
        metadata.propertyConcat("external_link", external_url, true);
        metadata = string(abi.encodePacked(metadata, "\n}"));
        return metadata;
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}

struct CardTier {
    string name;
    uint256 threshold;
}
