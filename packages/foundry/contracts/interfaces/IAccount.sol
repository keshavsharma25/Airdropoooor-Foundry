//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAccount {
    error NotAuthorized();

    fallback() external payable;

    receive() external payable;

    function getAirdropTokenAddress() external view returns (address);
    function isValidAirdrop() external view returns (bool);
    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue);
    function isValidSigner(
        address signer,
        bytes memory
    ) external view returns (bytes4);
    function owner() external view returns (address);
    function redeem() external;
    function setAirdropTokenAddress(address _airdropTokenAddress) external;
    function state() external view returns (uint256);
    function supportsInterface(bytes4 interfaceId) external pure returns (bool);
    function token() external view returns (uint256, address, uint256);
    function user() external view returns (address);
    function withdraw() external;
}
