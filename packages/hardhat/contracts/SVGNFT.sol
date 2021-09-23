// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./MetadataGenerator.sol";

contract SVGNFT is ERC721, Ownable {
    uint256 public tokenCounter;
    Monster[] internal monsters;

    event CreatedMonster(uint256 indexed tokenId);

    constructor() ERC721("Block Monster", "BLMST") {
        tokenCounter = 0;
    }

    struct Monster {
        uint8 color;
        uint256 chubbiness;
        uint8 batch;
    }

    function updateMonster(uint256 tokenId) public onlyOwner {
        monsters[tokenId].batch++;
        monsters[tokenId].chubbiness++;
    }

    function create(uint8 color, uint256 chubbiness) public {
        monsters.push(Monster(color, chubbiness, 0));
        _safeMint(msg.sender, tokenCounter);
        tokenCounter = tokenCounter + 1;
        emit CreatedMonster(tokenCounter);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "not exist");
        return
            MetadataGenerator.tokenURI(
                ownerOf(id),
                id,
                monsters[id].color,
                monsters[id].chubbiness,
                monsters[id].batch
            );
    }
}
