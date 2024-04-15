// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AirdropoooorLib as adLib} from "./lib/AirdropoooorLib.sol";
import {Maintainer} from "./Maintainer.sol";
import {Airdropoooor} from "./Airdropoooor.sol";

contract AirdropoooorFactory is Ownable {
    mapping(address => address) private _tokenAirdropMapper;

    constructor(address _owner) Ownable(_owner) {}

    function createAirDropoooor(
        string calldata _name,
        string calldata _symbol,
        string calldata _logo,
        address _airdropTokenAddr,
        address _admin,
        adLib.ToAirdrop[] calldata _airdropInfo,
        uint256 _deadlineTimestamp
    ) public payable {
        Maintainer maintainer = new Maintainer(_admin, _airdropTokenAddr);

        Airdropoooor airdrop = new Airdropoooor(
            _name,
            _symbol,
            _logo,
            _admin,
            address(maintainer),
            _deadlineTimestamp,
            _airdropInfo.length
        );

        _tokenAirdropMapper[address(airdrop)] = _airdropTokenAddr;
    }
}
