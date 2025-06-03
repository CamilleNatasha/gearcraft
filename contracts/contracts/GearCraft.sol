// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract GearCraft is ERC721, ERC1155 {
    uint256 public nextItemId;
    mapping(uint256 => string) public itemStats; // Blade + Hilt combos

    constructor() 
        ERC721("GearCraft", "GEAR") 
        ERC1155("https://api.gearcraft.com/items/{id}.json") 
    {}

    // Mint ERC1155 components (e.g., blades, hilts)
    function mintComponent(address to, uint256 id, uint256 amount) public {
        _mint(to, id, amount, "");
    }

    // Forge ERC721 item from components
    function forgeItem(uint256 bladeId, uint256 hiltId) public {
        _burn(msg.sender, bladeId, 1);
        _burn(msg.sender, hiltId, 1);
        uint256 newItemId = nextItemId++;
        _mint(msg.sender, newItemId);
        itemStats[newItemId] = string(abi.encodePacked("Blade:", bladeId, "|Hilt:", hiltId));
    }
}

// Staking Vault for ERC721 items (EIP4626)
contract ItemVault is ERC4626 {
    IERC721 public immutable nft;

    constructor(IERC721 _nft, address _gameCurrency) 
        ERC4626(IERC20(_gameCurrency), "StakedGear", "sGEAR") 
    {
        nft = _nft;
    }

    function stake(uint256 tokenId) public {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        _mint(msg.sender, 1e18); // 1:1 shares
    }
}