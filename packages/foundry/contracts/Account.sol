// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { IERC1271 } from "@openzeppelin/contracts/interfaces/IERC1271.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { SignatureChecker } from "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { IERC6551Account } from "../lib/erc6551/src/interfaces/IERC6551Account.sol";
import { ERC6551AccountLib } from "../lib/erc6551/src/lib/ERC6551AccountLib.sol";

import { IERC721A } from "../lib/erc721a/contracts/IERC721A.sol";
import { IERC4907A } from "../lib/erc721a/contracts/extensions/IERC4907A.sol";

import { IMaintainer } from "./interfaces/IMaintainer.sol";

/* ######################################################################### */
/*                              ERC6551: Account                             */
/* ######################################################################### */
contract Account is ERC165, IERC1271, IERC6551Account {
    /* ------------------------------- errors ------------------------------- */
    error NotAuthorized();

    /* -------------------------- state variables -------------------------- */
    uint256 public state;

    address private airdropTokenAddress;

    /* ------------------------------ receive ------------------------------ */

    receive() external payable {}
    fallback() external payable {}

    /* ----------------------------- modifiers ----------------------------- */
    modifier onlyOwner() {
        require(msg.sender == owner(), "Unauthorized! Owner only.");
        _;
    }

    modifier onlyUser() {
        require(msg.sender == user(), "Unauthorized! Tenant(user) only.");
        _;
    }

    /* ------------------------------- public ------------------------------ */
    function setAirdropTokenAddress(
        address _airdropTokenAddress
    ) public onlyOwner {
        require(
            airdropTokenAddress == address(0),
            "AIRDROP_TOKEN_ADDRESS already set once."
        );

        airdropTokenAddress = _airdropTokenAddress;
    }

    function redeem() public onlyUser {
        require(airdropTokenAddress != address(0), "Invalid Airdrop Token");
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();

        require(
            chainId == block.chainid,
            string.concat("Invalid chain id:", Strings.toString(block.chainid))
        );

        uint256 balance = IERC20(airdropTokenAddress).balanceOf(address(this));

        require(balance > 0, "No tokens available for airdrop claim.");

        if (msg.sender == user() && isValidAirdrop()) {
            IERC20(airdropTokenAddress).transferFrom(
                address(this),
                msg.sender,
                balance
            );

            IMaintainer(payable(owner())).setIsClaimed(tokenId);
            IERC721A(tokenContract).transferFrom(owner(), user(), tokenId);
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = IERC20(airdropTokenAddress).balanceOf(address(this));

        if (!isValidAirdrop()) {
            IERC20(airdropTokenAddress).transfer(msg.sender, balance);
        }
    }

    function isValidAirdrop() public view returns (bool) {
        (, address tokenContract, uint256 tokenId) = token();
        uint256 expires = IERC4907A(tokenContract).userExpires(tokenId);

        return block.timestamp < expires;
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC721A(tokenContract).ownerOf(tokenId);
    }

    function user() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC4907A(tokenContract).userOf(tokenId);
    }

    function token() public view returns (uint256, address, uint256) {
        bytes memory footer = new bytes(0x60);

        assembly {
            extcodecopy(address(), add(footer, 0x20), 0x4d, 0x60)
        }

        return abi.decode(footer, (uint256, address, uint256));
    }

    function getAirdropTokenAddress() public view returns (address) {
        return airdropTokenAddress;
    }

    function isValidSigner(
        address signer,
        bytes calldata
    ) external view returns (bytes4) {
        if (_isValidSigner(signer)) {
            return IERC6551Account.isValidSigner.selector;
        }

        return bytes4(0);
    }

    /* ------------------------------ external ----------------------------- */
    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue) {
        bool isValid = SignatureChecker.isValidSignatureNow(
            owner(),
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return bytes4(0);
    }

    /* ------------------------------ internal ----------------------------- */
    function _isValidSigner(address signer) internal view returns (bool) {
        return signer == owner();
    }

    /* ----------------------------- override ---------------------------- */

    function supportsInterface(
        bytes4 interfaceId
    ) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId;
    }
}
