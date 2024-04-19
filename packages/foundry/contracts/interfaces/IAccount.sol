//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAccount {
    function setAirdropTokenAddress(address airdropTokenAddress) external;

    function withdraw() external;
}
