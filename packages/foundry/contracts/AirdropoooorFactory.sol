// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { AirdropoooorLib as adl } from "./lib/AirdropoooorLib.sol";
import { Maintainer } from "./Maintainer.sol";
import { Airdropoooor } from "./Airdropoooor.sol";
import { IAirdropoooor } from "./interfaces/IAirdropoooor.sol";

/* ######################################################################### */
/*                            AirdropoooorFactory                            */
/* ######################################################################### */
contract AirdropoooorFactory is Ownable {
    /* ------------------------------- events ------------------------------ */

    event CreateAirdropoooor(
        address indexed airdropoooor,
        address maintainer,
        address tokenAddress
    );

    /* -------------------------- state variables -------------------------- */
    address public immutable REGISTRY_ADDRESS;
    mapping(address => address) private _tokenAirdropMapper;

    /* ---------------------------- constructor ---------------------------- */
    constructor(address _owner, address _registry) Ownable(_owner) {
        REGISTRY_ADDRESS = _registry;
    }

    /* ------------------------------- public ------------------------------ */
    function createAirdropoooor(
        string calldata _name,
        string calldata _symbol,
        address _airdropTokenAddr,
        address _admin,
        adl.ToAirdrop[] memory _airdropInfo,
        uint256 _deadlineTimestamp
    ) public payable {
        Maintainer maintainer = new Maintainer(
            _admin,
            _airdropTokenAddr,
            _airdropInfo,
            _deadlineTimestamp,
            REGISTRY_ADDRESS,
            address(this)
        );

        Airdropoooor airdrop = new Airdropoooor(
            _name,
            _symbol,
            _admin,
            address(maintainer),
            _airdropInfo.length
        );

        maintainer.setAirdropoooorAddress(address(airdrop));
        _tokenAirdropMapper[address(airdrop)] = _airdropTokenAddr;

        emit CreateAirdropoooor(
            address(airdrop),
            address(maintainer),
            _airdropTokenAddr
        );
    }
}
