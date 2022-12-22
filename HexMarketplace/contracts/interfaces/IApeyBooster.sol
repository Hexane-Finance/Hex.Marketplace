// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IApeyBooster {
    function getBoosterId(uint256 _tokenId) external view returns (uint8);
}
