// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ICollectionWhitelistChecker} from "./interfaces/ICollectionWhitelistChecker.sol";
import {IApeyBooster} from "./interfaces/IApeyBooster.sol";

contract ApeyBoosterWhitelistChecker is Ownable, ICollectionWhitelistChecker {
    IApeyBooster public ApeyBooster;

    mapping(uint8 => bool) public isBoosterIdRestricted;

    event NewRestriction(uint8[] BoosterIds);
    event RemoveRestriction(uint8[] BoosterIds);

    /**
     * @notice Constructor
     * @param _ApeyBoosterAddress: ApeyBooster contract
     */
    constructor(address _ApeyBoosterAddress) {
        ApeyBooster = IApeyBooster(_ApeyBoosterAddress);
    }

    /**
     * @notice Restrict tokens with specific BoosterIds to be sold
     * @param _BoosterIds: BoosterIds to restrict for trading on the market
     */
    function addRestrictionForBunnies(uint8[] calldata _BoosterIds) external onlyOwner {
        for (uint8 i = 0; i < _BoosterIds.length; i++) {
            require(!isBoosterIdRestricted[_BoosterIds[i]], "Operations: Already restricted");
            isBoosterIdRestricted[_BoosterIds[i]] = true;
        }

        emit NewRestriction(_BoosterIds);
    }

    /**
     * @notice Remove restrictions tokens with specific BoosterIds to be sold
     * @param _BoosterIds: BoosterIds to restrict for trading on the market
     */
    function removeRestrictionForBunnies(uint8[] calldata _BoosterIds) external onlyOwner {
        for (uint8 i = 0; i < _BoosterIds.length; i++) {
            require(isBoosterIdRestricted[_BoosterIds[i]], "Operations: Not restricted");
            isBoosterIdRestricted[_BoosterIds[i]] = false;
        }

        emit RemoveRestriction(_BoosterIds);
    }

    /**
     * @notice Check whether token can be listed
     * @param _tokenId: tokenId of the NFT to list
     */
    function canList(uint256 _tokenId) external view override returns (bool) {
        uint8 BoosterId = ApeyBooster.getBoosterId(_tokenId);

        return !isBoosterIdRestricted[BoosterId];
    }
}
