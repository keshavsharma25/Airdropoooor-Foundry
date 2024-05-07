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

    /* -------------------------------- structs ------------------------------- */

    struct Contracts {
        address maintainer;
        address airdropoooor;
    }

    /* -------------------------- state variables -------------------------- */

    address public immutable REGISTRY_ADDRESS;
    uint256 private _nextTokenId;
    mapping(uint256 => Contracts) private _contracts;
    mapping(address => uint256[]) private _ownerIdMap;

    /* ---------------------------- constructor ---------------------------- */

    constructor(address _owner, address _registry) Ownable(_owner) {
        REGISTRY_ADDRESS = _registry;
    }

    /* -------------------------- fallback & receive -------------------------- */

    receive() external payable {}

    fallback() external payable {}

    /* ------------------------------- public ------------------------------ */
    function createAirdropoooor(
        string calldata _name,
        string calldata _symbol,
        address _airdropTokenAddr,
        address _admin,
        adl.ToAirdrop[] memory _airdropInfo,
        uint256 _deadlineTimestamp
    ) public {
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
        _contracts[_nextTokenId] = Contracts({
            maintainer: address(maintainer),
            airdropoooor: address(airdrop)
        });

        uint256[] storage _data = _ownerIdMap[_admin];
        _data.push(_nextTokenId);

        _nextTokenId += 1;

        emit CreateAirdropoooor(
            address(airdrop),
            address(maintainer),
            _airdropTokenAddr
        );
    }

    function getNoAirdropoooors() public view returns (uint256) {
        return _nextTokenId;
    }

    function getContractsInfo(
        uint256 id
    ) public view returns (address, address) {
        return (_contracts[id].airdropoooor, _contracts[id].maintainer);
    }

    function getRentedTokensForUser(
        address user
    ) public view returns (int256[] memory) {
        int256[] memory data;

        for (uint i = 0; i < _nextTokenId; i++) {
            (address airdropoooor, ) = getContractsInfo(i);
            int256 value = IAirdropoooor(airdropoooor).getTenantTokenId(user);
            data[i] = value;
        }

        return data;
    }

    function getIdsByOwner(
        address owner
    ) public view returns (uint256[] memory) {
        return _ownerIdMap[owner];
    }
}
