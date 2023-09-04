// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Barbarian is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Barbarian", "BRN") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://Qmaa6TuP2s9pSKczHF4rwWhTKUdygrrDs8RmYYqCjP3Hye/";
    }
    uint256 maxSupply = 10;
    bool allowListMintPerm = false;
    bool publicMintPerm = false;
    mapping(address=>bool) public allowList;

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mintWindows (bool _allowListMintPerm, bool _publicMintPerm ) external onlyOwner{
        allowListMintPerm = _allowListMintPerm;
        publicMintPerm = _publicMintPerm;

    }

    function allowListMint() public payable  {
        require(allowListMintPerm);
        require(allowList[msg.sender]);
        require(msg.value == 0.001 ether,"not enough money");
        intMint();
    }

    function safeMint() public payable  {
        require(publicMintPerm);
        require(msg.value == 1 ether,"not enough money");
        intMint();
    }


    function intMint() internal  {
        require(totalSupply() < maxSupply,"u cant mint ");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function setAllowList(address[] calldata addresses) external onlyOwner {
        for(uint256 i= 0; i < addresses.length; i++ ) {
            allowList[addresses[i]] = true;
        }
    }

    function withdraw(address _addr) external onlyOwner{
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}