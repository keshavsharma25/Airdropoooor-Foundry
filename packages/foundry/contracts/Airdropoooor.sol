// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {IERC4907} from "./interfaces/IERC4907.sol";
import {ERC721A} from "erc721a/contracts/ERC721A.sol";

/* ######################################################################### */
/*                                Airdropoooor                               */
/* ######################################################################### */
contract Airdropoooor is ERC721A, IERC4907, Ownable {
    struct UserInfo {
        address user;
        uint256 expires;
    }

    string public logoURI;

    mapping(uint256 => UserInfo) private _users;

    uint256 immutable DEADLINE_TIMESTAMP;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _logo,
        address _owner,
        address _maintainer,
        uint256 _deadlineTimestamp,
        uint256 _noAirdrops
    ) ERC721A(_name, _symbol) Ownable(_owner) {
        DEADLINE_TIMESTAMP = _deadlineTimestamp;
        logoURI = _logo;

        _safeMint(_maintainer, _noAirdrops);
    }

    /* ----------------------------- public ----------------------------- */

    function setUser(uint256 tokenId, address user, uint64 expires) public {
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "ERC4907: transfer caller is not owner nor approved"
        );
        UserInfo storage info = _users[tokenId];
        info.user = user;
        info.expires = DEADLINE_TIMESTAMP;
        emit UpdateUser(tokenId, user, expires);
    }

    function userOf(uint256 tokenId) public view returns (address) {
        if (uint256(_users[tokenId].expires) >= block.timestamp) {
            return _users[tokenId].user;
        } else {
            return address(0);
        }
    }

    function userExpires(uint256 _tokenId) public view returns (uint256) {
        return _users[_tokenId].expires;
    }

    function getAbbrvTBA(
        uint256 _tokenId
    ) public view returns (string memory) {}

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        return
            string.concat(
                '<svg width="400" height="400" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">',
                '<rect width="400" height="400" rx="40" fill="url(#a)"/>',
                '<circle cx="199.5" cy="131.5" r="81.5" stroke="#130912" stroke-width="2"/>',
                '<text fill="#130912" xml:space="preserve" style="white-space:pre" font-family="Noto Sans" font-size="36" letter-spacing="0em"><tspan x="149" y="121.468">MOCK</tspan><tspan x="149" y="170.468">ERC20</tspan></text>',
                '<text fill="#130912" xml:space="preserve" style="white-space:pre" font-family="Noto Sans" font-size="20" letter-spacing="0em"><tspan x="150" y="272.26">TokenID : ',
                Strings.toString(_tokenId),
                "</tspan></text>",
                '<text fill="#130912" xml:space="preserve" style="white-space:pre" font-family="Noto Sans" font-size="20" letter-spacing="0em"><tspan x="117" y="302.26">TBA : ',
                getAbbrvTBA(_tokenId),
                "</tspan></text>",
                "<defs>",
                '<linearGradient id="a" x1="-62.5" y1="-57" x2="414" y2="422" gradientUnits="userSpaceOnUse">',
                '<stop stop-color="#8386FD"/>',
                '<stop offset="1" stop-color="#E192A7"/>',
                "</linearGradient>",
                "</defs>",
                "</svg>"
            );
    }

    /* ----------------------------- internal ---------------------------- */

    function _isApprovedOrOwner(
        address addr,
        uint256 tokenId
    ) internal view returns (bool) {
        address approvedAddr = getApproved(tokenId);

        if (owner() == addr || approvedAddr == addr) {
            return true;
        }
        return false;
    }

    /* ---------------------------- override ---------------------------- */

    function supportsInterface(
        bytes4 interfaceId
    ) public view override returns (bool) {
        return
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
