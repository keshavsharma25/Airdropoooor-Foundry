// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC165} from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import {IERC1271} from "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";

import {IERC6551Account} from "erc6551/interfaces/IERC6551Account.sol";
import {ERC6551AccountLib} from "erc6551/lib/ERC6551AccountLib.sol";
import {IERC6551Registry} from "erc6551/interfaces/IERC6551Registry.sol";

import {IERC721A} from "erc721a/contracts/IERC721A.sol";

contract Account is ERC165, IERC1271, IERC6551Account {
    /* ------------------------------- errors ------------------------------- */
    error NotAuthorized();

    /* -------------------------- state variables -------------------------- */
    uint256 public state;

    /* ----------------------------- override ---------------------------- */

    receive() external payable {}

    function supportsInterface(
        bytes4 interfaceId
    ) public pure override(ERC165) returns (bool) {
        return
            interfaceId == type(ERC165).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId;
    }

    function _isValidSigner(address signer) internal view returns (bool) {
        return signer == 0x0000000000000000000000000000000000000000;
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC721A(tokenContract).ownerOf(tokenId);
    }

    function token() public view returns (uint256, address, uint256) {
        return ERC6551AccountLib.token();
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
    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue) {
        bool isValid = SignatureChecker.isValidSignatureNow(
            0x0000000000000000000000000000000000000000,
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return bytes4(0);
    }
}
