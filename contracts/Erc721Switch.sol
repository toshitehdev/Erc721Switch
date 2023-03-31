//SPDX-License-Identifier: MIT

//NFT that you can trade on DEX
//NFT that will NEVER goes to 0 in value, even if there's no buy offer!
//website: https://ercordinal.io
//telegram: https://t.me/ercordinal
//twitter: https://twitter.com/ErcOrdinal
//learn more: https://medium.com/@toshitehdev/ercordinal-implementing-ordinal-system-on-erc20-interface-13f85b299a48

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.7;

interface IErcord {
    function getIdToTokens(uint256 _id) external view returns (address);

    function erc721Switch(address _from, uint256 _id) external;

    function transferMany(address _recipient, uint256[] memory _ids) external;

    function claimViaErc721(uint256 _id, address _owner) external;
}

contract Erc721Switch is ERC721 {
    //ercord erc20 address
    address ercordAddress = 0xC85f1A1BAaEe1E4E892EdF78e4c0A7a376459bDC;
    mapping(uint256 => bool) idMinted;

    constructor() ERC721("ErcOrdinal", "ERCORD") {}

    function _baseURI() internal pure override returns (string memory) {
        return
            "ipfs://bafybeibqknpxt2dc2s3o5ulfsvqognymzzaot2xk6hkwonhq3qmyerljfe/";
    }

    function switchToErc721(uint256 _id) public returns (bool) {
        //read ercord erc20 owner
        require(
            IErcord(ercordAddress).getIdToTokens(_id) == msg.sender,
            "Must be the owner"
        );
        //switch, send ercord from owner to this address
        IErcord(ercordAddress).erc721Switch(msg.sender, _id);

        if (idMinted[_id] == true) {
            //if this adress is the owner (been minted before, and switched back) of erc721, transfer
            _transfer(address(this), msg.sender, _id);
        } else {
            //if this address is NOT the owner (haven't been minted), mint
            _mint(msg.sender, _id);
            idMinted[_id] = true;
        }
        return true;
    }

    //switch eNFT back to ercord erc20
    function switchToErcord(uint256[] memory _ids) public returns (bool) {
        require(_ids.length == 1, "Can only switch one at a time");
        require(ownerOf(_ids[0]) == msg.sender, "Must be the owner");
        //transfer erc20 to the owner
        IErcord(ercordAddress).transferMany(msg.sender, _ids);
        //transfer eNft to contract address
        _transfer(msg.sender, address(this), _ids[0]);
        return true;
    }

    function claimFreeMint(uint256 _id) public returns (bool) {
        require(ownerOf(_id) == msg.sender, "Must be the owner");
        IErcord(ercordAddress).claimViaErc721(_id, address(this));
        return true;
    }

    function tokenURI(
        uint256 tokenId
    ) public pure override returns (string memory) {
        string memory id = Strings.toString(tokenId);
        return string.concat(_baseURI(), id, ".json");
    }
}
