//SPDX-License-Identifier: MIT
//https://ercordinal.io
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.7;

interface IErcord {
    function getIdToTokens(uint256 _id) external view returns (address);

    function erc721Switch(address _from, uint256 _id) external;

    function transferMany(address _recipient, uint256[] memory _ids) external;
}

contract Erc721Switch is ERC721 {
    //ercord erc20 address
    address ercordAddress = 0x1bACc44C0E404dA1718c36cdD2a73aFA1B8E2d30;
    uint256 private s_tokenCounter;

    constructor() ERC721("ErcOrdinal", "ERCORD") {
        s_tokenCounter = 0;
    }

    function _baseURI() internal pure override returns (string memory) {
        return
            "ipfs://bafybeibqknpxt2dc2s3o5ulfsvqognymzzaot2xk6hkwonhq3qmyerljfe/";
    }

    function switchToErc721(uint256 _id) public returns (uint256) {
        //read ercord erc20 owner
        require(
            IErcord(ercordAddress).getIdToTokens(_id) == msg.sender,
            "Must be the owner"
        );
        //switch, send ercord to this address
        IErcord(ercordAddress).erc721Switch(msg.sender, _id);

        if (ownerOf(_id) == address(this)) {
            //if this adress is the owner (been minted before, and switched back) of erc721, transfer
            _transfer(address(this), msg.sender, _id);
        } else {
            //if this address is NOT the owner (haven't been minted), mint
            _safeMint(msg.sender, _id);
        }

        s_tokenCounter = s_tokenCounter + 1;
        return s_tokenCounter;
    }

    //switch eNFT back to ercord erc20
    function switchToErcord(uint256[] memory _ids) public {
        require(_ids.length == 1, "Can only switch one at a time");
        require(ownerOf(_ids[0]) == msg.sender, "Must be the owner");
        //transfer erc20 to the owner
        IErcord(ercordAddress).transferMany(msg.sender, _ids);
        //transfer eNft to contract address
        _transfer(msg.sender, address(this), _ids[0]);
    }

    function tokenURI(
        uint256 tokenId
    ) public pure override returns (string memory) {
        string memory id = Strings.toString(tokenId);
        return string.concat(_baseURI(), id, ".json");
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
