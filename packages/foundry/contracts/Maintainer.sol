// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC721Holder } from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import { IERC6551Registry } from "../lib/erc6551/src/interfaces/IERC6551Registry.sol";
import { IERC4907A } from "../lib/erc721a/contracts/interfaces/IERC4907A.sol";
import { IERC721A } from "../lib/erc721a/contracts/interfaces/IERC721A.sol";

import { AirdropoooorLib as adl } from "./lib/AirdropoooorLib.sol";
import { Account } from "./Account.sol";
import { IAccount } from "./interfaces/IAccount.sol";
import { IAirdropoooor } from "./interfaces/IAirdropoooor.sol";

import { console } from "forge-std/console.sol";

/* ######################################################################### */
/*                                 Maintainer                                */
/* ######################################################################### */
contract Maintainer is Ownable, ERC721Holder {
    /* ------------------------------- events ------------------------------ */

    /* -------------------------- state variables -------------------------- */

    address public immutable AIRDROP_TOKEN_ADDRESS;
    address public immutable REGISTRY_ADDRESS;
    address public immutable FACTORY_ADDRESS;
    address public IMPLEMENTATION_ADDRESS;
    address public AIRDROPOOOOR_ADDRESS;

    mapping(uint256 => adl.TbaToAirdrop) private _tbaAirdropInfo;

    uint256 public immutable DEADLINE_TIMESTAMP;
    uint256 public totalAirdropAmount;
    uint256 public totalAirdrops;

    /* ---------------------------- constructor ---------------------------- */

    constructor(
        address _owner,
        address _airdropTokenAddr,
        address[] memory _airdropAddresses,
        uint256[] memory _airdropAmounts,
        uint256 _deadlineTimestamp,
        address _registry,
        address _factory
    ) Ownable(_owner) {
        AIRDROP_TOKEN_ADDRESS = _airdropTokenAddr;
        REGISTRY_ADDRESS = _registry;
        FACTORY_ADDRESS = _factory;
        DEADLINE_TIMESTAMP = _deadlineTimestamp;

        _populateTbaAirdropInfo(_airdropAddresses, _airdropAmounts);
    }

    /* -------------------------------- receive ------------------------------- */

    receive() external payable {}
    fallback() external payable {}

    /* ------------------------------- public ------------------------------ */

    function fundAirdropInTBAs() public payable onlyOwner {
        require(
            contractTokenBalance() >= totalAirdropAmount,
            "Not enough balance in Maintainer to fund TBAs!"
        );

        IERC6551Registry registry = IERC6551Registry(REGISTRY_ADDRESS);

        Account newAcc = new Account();
        IMPLEMENTATION_ADDRESS = address(newAcc);

        for (uint256 i = 0; i < totalAirdrops; i++) {
            address tba = registry.createAccount(
                address(newAcc),
                bytes32(0),
                block.chainid,
                AIRDROPOOOOR_ADDRESS,
                i
            );

            IAccount(payable(tba)).setAirdropTokenAddress(
                AIRDROP_TOKEN_ADDRESS
            );

            IERC4907A(AIRDROPOOOOR_ADDRESS).setUser(
                i,
                _tbaAirdropInfo[i].toAddress,
                uint64(DEADLINE_TIMESTAMP)
            );

            uint256 tbaAmount = _tbaAirdropInfo[i].amount;

            IERC20(AIRDROP_TOKEN_ADDRESS).transfer(tba, tbaAmount);
        }
    }

    function withdrawFromTBAs() public onlyOwner {
        require(
            block.timestamp > DEADLINE_TIMESTAMP,
            "Deadline not yet reached!"
        );
        for (uint256 i = 0; i < totalAirdrops; i++) {
            address tba = getTBA(i);

            if (_tbaAirdropInfo[i].isClaimed) {
                continue;
            }

            if (tbaTokenBalance(i) > 0) {
                IAccount TbaAcc = IAccount(payable(tba));

                TbaAcc.withdraw();
                _tbaAirdropInfo[i].isWithdrawn = true;
                IAirdropoooor(AIRDROPOOOOR_ADDRESS).burn(i);
            }
        }
    }

    function depositTotalAirdropAmount() public onlyOwner {
        IERC20 token = IERC20(AIRDROP_TOKEN_ADDRESS);
        uint256 allowance = token.allowance(msg.sender, address(this));

        require(
            allowance >= totalAirdropAmount,
            string.concat(
                "Not enough allowance! The allowance should be ",
                Strings.toString(totalAirdropAmount)
            )
        );

        token.transferFrom(msg.sender, address(this), totalAirdropAmount);
    }

    function setAirdropoooorAddress(address _airdropoooorAddress) public {
        require(
            msg.sender == FACTORY_ADDRESS,
            "ONLY AIRDROPOOOOR_FACTORY can set AIRDROPOOOOR_ADDRESS"
        );
        require(
            AIRDROPOOOOR_ADDRESS == address(0),
            "AIRDROPOOOOR_ADDRESS set already once."
        );

        AIRDROPOOOOR_ADDRESS = _airdropoooorAddress;
    }

    function setIsClaimed(uint256 _tokenId) public {
        require(
            msg.sender == getTBA(_tokenId),
            "Restricted! Only Token Bound Accounts can interact!"
        );
        require(
            _tbaAirdropInfo[_tokenId].isClaimed == false,
            "Already claimed by the user!"
        );

        _tbaAirdropInfo[_tokenId].isClaimed = true;
        _approveAirdropoooor(_tokenId);
    }

    function getAirdropInfo(
        uint256 _tokenId
    ) public view returns (adl.TbaToAirdrop memory) {
        return _tbaAirdropInfo[_tokenId];
    }

    function getAirdropAmount(uint256 _tokenId) public view returns (uint256) {
        return _tbaAirdropInfo[_tokenId].amount;
    }

    function getTBA(uint256 _tokenId) public view returns (address) {
        IERC6551Registry registry = IERC6551Registry(REGISTRY_ADDRESS);

        return
            registry.account(
                IMPLEMENTATION_ADDRESS,
                bytes32(0),
                block.chainid,
                AIRDROPOOOOR_ADDRESS,
                _tokenId
            );
    }

    function isClaimed(uint256 _tokenId) public view returns (bool) {
        return _tbaAirdropInfo[_tokenId].isClaimed;
    }

    function contractTokenBalance() public view returns (uint256) {
        IERC20 token = IERC20(AIRDROP_TOKEN_ADDRESS);

        return token.balanceOf(address(this));
    }

    function tbaTokenBalance(uint256 _tokenId) public view returns (uint256) {
        IERC20 token = IERC20(AIRDROP_TOKEN_ADDRESS);

        return token.balanceOf(getTBA(_tokenId));
    }

    /* ------------------------------ private ------------------------------ */

    function _populateTbaAirdropInfo(
        address[] memory _airdropAddresses,
        uint256[] memory _airdropAmounts
    ) private {
        uint256 sumAirdropAmount = 0;

        for (uint256 i = 0; i < _airdropAddresses.length; i++) {
            address tba = getTBA(i);

            _tbaAirdropInfo[i] = adl.TbaToAirdrop({
                toAddress: _airdropAddresses[i],
                tbaAddress: tba,
                amount: _airdropAmounts[i],
                isClaimed: false,
                isWithdrawn: false
            });

            sumAirdropAmount += _airdropAmounts[i];
        }

        totalAirdropAmount += sumAirdropAmount;
        totalAirdrops = _airdropAddresses.length;
    }

    function _approveAirdropoooor(uint256 _tokenId) private {
        IERC721A(AIRDROPOOOOR_ADDRESS).approve(
            _tbaAirdropInfo[_tokenId].toAddress,
            _tokenId
        );
    }
}
