// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC721Receiver } from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";

interface IMaintainer {
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    receive() external payable;

    function AIRDROPOOOOR_ADDRESS() external view returns (address);
    function AIRDROP_TOKEN_ADDRESS() external view returns (address);
    function DEADLINE_TIMESTAMP() external view returns (uint256);
    function FACTORY_ADDRESS() external view returns (address);
    function IMPLEMENTATION_ADDRESS() external view returns (address);
    function REGISTRY_ADDRESS() external view returns (address);
    function contractTokenBalance() external view returns (uint256);
    function depositTotalAirdropAmount() external;
    function fundAirdropInTBAs() external;
    function getAirdropAmount(uint256 _tokenId) external view returns (uint256);
    function getTBA(uint256 _tokenId) external view returns (address);
    function isClaimed(uint256 _tokenId) external view returns (bool);
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external returns (bytes4);
    function owner() external view returns (address);
    function renounceOwnership() external;
    function setAirdropoooorAddress(address _airdropoooorAddress) external;
    function setIsClaimed(uint256 _tokenId) external;
    function tbaTokenBalance(uint256 _tokenId) external view returns (uint256);
    function totalAirdropAmount() external view returns (uint256);
    function totalAirdrops() external view returns (uint256);
    function transferOwnership(address newOwner) external;
    function withdrawFromTBAs() external;
}
