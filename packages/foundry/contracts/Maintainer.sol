// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AirdropoooorLib as adLib} from "./lib/AirdropoooorLib.sol";

contract Maintainer is Ownable {
    address private immutable AIRDROP_TOKEN_ADDRESS;

    mapping(address => uint256) private _airdropAmount;

    constructor(address _owner, address _airdropTokenAddr) Ownable(_owner) {
        AIRDROP_TOKEN_ADDRESS = _airdropTokenAddr;
    }

    /* ------------------------------- public ------------------------------ */

    function redeemFromTBA() public onlyOwner {}

    function fundAirdropInTBA() public onlyOwner {}

    function getAirdropTokenAddress() public view returns(address) {
        return AIRDROP_TOKEN_ADDRESS;
    }

    function getAirdropAmount(address _user) public view returns(uint256) {
        return _airdropAmount[_user];
    }
}
