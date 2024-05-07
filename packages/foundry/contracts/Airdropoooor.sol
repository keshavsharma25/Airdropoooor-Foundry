// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { ERC4907A } from "erc721a/contracts/extensions/ERC4907A.sol";
import { IERC4907A } from "erc721a/contracts/extensions/IERC4907A.sol";
import { ERC721A } from "erc721a/contracts/ERC721A.sol";
import { IERC721A } from "erc721a/contracts/IERC721A.sol";
import { ERC721ABurnable } from "erc721a/contracts/extensions/ERC721ABurnable.sol";
import { IMaintainer } from "./interfaces/IMaintainer.sol";

/* ######################################################################### */
/*                                Airdropoooor                               */
/* ######################################################################### */
contract Airdropoooor is ERC4907A, ERC721ABurnable, Ownable {
    address public immutable MAINTAINER_ADDRESS;
    mapping(address => uint256) private _userTokenIdMap;

    constructor(
        string memory _name,
        string memory _symbol,
        address _owner,
        address _maintainer,
        uint256 _noAirdrops
    ) ERC721A(_name, _symbol) Ownable(_owner) {
        MAINTAINER_ADDRESS = _maintainer;
        _safeMint(_maintainer, _noAirdrops);
    }

    /* ----------------------------- public ----------------------------- */

    function getTenantTokenId(address _user) public view returns (int256) {
        uint256 id = _userTokenIdMap[_user];

        if (id > 0 && userExpires(id) < block.timestamp) {
            return int256(id);
        }

        return -1;
    }

    /* ---------------------------- override ---------------------------- */

    function _safeMint(address to, uint256 quantity) internal override {
        super._safeMint(to, quantity);
    }

    function burn(uint256 _tokenId) public override {
        require(
            msg.sender == MAINTAINER_ADDRESS,
            "Only MAINTAINER can burn em!"
        );
        super.burn(_tokenId);
    }

    function setUser(
        uint256 tokenId,
        address user,
        uint64 expires
    ) public override {
        require(
            msg.sender == MAINTAINER_ADDRESS,
            "User can only be set by Maintainer contract."
        );

        super.setUser(tokenId, user, expires);
        _userTokenIdMap[user] = tokenId;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC4907A, ERC721A, IERC721A) returns (bool) {
        return
            interfaceId == type(IERC4907A).interfaceId ||
            interfaceId == type(IERC721A).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override(ERC721A, IERC721A) returns (string memory) {
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
}
