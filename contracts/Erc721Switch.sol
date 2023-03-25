//SPDX-License-Identifier: MIT
//https://ercordinal.io
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

pragma solidity ^0.8.7;

interface IErcord {
    function getIdToTokens(uint256 _id) external view returns (address);

    function erc721Switch(address _from, uint256 _id) external;
}

contract Erc721Switch is ERC721 {
    //ercord erc20 address
    address ercordAddress = 0x1bACc44C0E404dA1718c36cdD2a73aFA1B8E2d30;
    uint256 private s_tokenCounter;

    constructor() ERC721("ErcOrdinal", "ERCORD") {
        s_tokenCounter = 0;
    }

    function mintNft(uint256 _id) public returns (uint256) {
        //read ercord erc20 owner
        require(
            IErcord(ercordAddress).getIdToTokens(_id) == msg.sender,
            "Must be the owner"
        );
        //switch
        IErcord(ercordAddress).erc721Switch(msg.sender, _id);
        //mint
        _safeMint(msg.sender, _id);
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
