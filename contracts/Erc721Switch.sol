//SPDX-License-Identifier: MIT
//https://ercordinal.io
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

pragma solidity ^0.8.7;

contract Erc721Switch is ERC721 {
    uint256 private s_tokenCounter;

    constructor() ERC721("ErcORdinal", "ERCORD") {
        s_tokenCounter = 0;
    }

    function mintNft() public returns (uint256) {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
        return s_tokenCounter;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return "asdasd";
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
