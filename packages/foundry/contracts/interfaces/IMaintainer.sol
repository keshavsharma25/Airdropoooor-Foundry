// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMaintainer {
    function setIsClaimed(uint256 _tokenId) external;
}
