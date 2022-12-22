// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/** @title ApeyBooster.
 * @notice It is the contracts for PancakeSwap NFTs.
 */
contract ApeyBooster is ERC721, Ownable {
    using Counters for Counters.Counter;

    // Map the number of tokens per BoosterId
    mapping(uint8 => uint256) public BoosterCount;

    // Map the number of tokens burnt per BoosterId
    mapping(uint8 => uint256) public BoosterBurnCount;

    // Used for generating the tokenId of new NFT minted
    Counters.Counter private _tokenIds;

    // Map the BoosterId for each tokenId
    mapping(uint256 => uint8) private BoosterIds;

    // Map the BoosterName for a tokenId
    mapping(uint8 => string) private BoosterNames;

    constructor() ERC721("Apey Booster", "PB") {
        //
    }

    /**
     * @dev Get BoosterId for a specific tokenId.
     */
    function getBoosterId(uint256 _tokenId) external view returns (uint8) {
        return BoosterIds[_tokenId];
    }

    /**
     * @dev Get the associated BoosterName for a specific BoosterId.
     */
    function getBoosterName(uint8 _BoosterId) external view returns (string memory) {
        return BoosterNames[_BoosterId];
    }

    /**
     * @dev Get the associated BoosterName for a unique tokenId.
     */
    function getBoosterNameOfTokenId(uint256 _tokenId) external view returns (string memory) {
        uint8 BoosterId = BoosterIds[_tokenId];
        return BoosterNames[BoosterId];
    }

    /**
     * @dev Mint NFTs. Only the owner can call it.
     */
    function mint(
        address _to,
        string calldata _tokenURI,
        uint8 _BoosterId
    ) external onlyOwner returns (uint256) {
        uint256 newId = _tokenIds.current();
        _tokenIds.increment();
        BoosterIds[newId] = _BoosterId;
        BoosterCount[_BoosterId]++;
        _mint(_to, newId);
        return newId;
    }

    /**
     * @dev Set a unique name for each BoosterId. It is supposed to be called once.
     */
    function setBoosterName(uint8 _BoosterId, string calldata _name) external onlyOwner {
        BoosterNames[_BoosterId] = _name;
    }

    /**
     * @dev Burn a NFT token. Callable by owner only.
     */
    function burn(uint256 _tokenId) external onlyOwner {
        uint8 BoosterIdBurnt = BoosterIds[_tokenId];
        BoosterCount[BoosterIdBurnt]--;
        BoosterBurnCount[BoosterIdBurnt]++;
        _burn(_tokenId);
    }
}
