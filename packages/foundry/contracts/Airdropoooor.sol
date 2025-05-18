// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { ERC4907A } from "../lib/erc721a/contracts/extensions/ERC4907A.sol";
import { IERC4907A } from "../lib/erc721a/contracts/extensions/IERC4907A.sol";
import { ERC721A } from "../lib/erc721a/contracts/ERC721A.sol";
import { IERC721A } from "../lib/erc721a/contracts/IERC721A.sol";
import { ERC721ABurnable } from "../lib/erc721a/contracts/extensions/ERC721ABurnable.sol";
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

    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal override {
        require(
            from == MAINTAINER_ADDRESS || from == address(0),
            "Soulbound Token! Cannot transfer..."
        );
        super._beforeTokenTransfers(from, to, startTokenId, quantity);
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
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            string.concat(
                                '{ "name": "',
                                name(),
                                '", "image": "data:image/svg+xml;base64,',
                                Base64.encode(bytes(_tokenSVG(_tokenId))),
                                '", "description": "Airdropoooor: claim your airdrops with ease"}'
                            )
                        )
                    )
                )
            );
    }

    function _tokenSVG(uint256 _tokenId) internal view returns (string memory) {
        bool isClaimed = IMaintainer(payable(MAINTAINER_ADDRESS)).isClaimed(
            _tokenId
        );

        string memory svg = string.concat(
            '<svg width="400" height="400" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">',
            '<rect width="400" height="400" rx="40" fill="url(#paint0_linear_1734_831)"/>',
            '<text fill="#130912" xml:space="preserve" style="white-space: pre" font-family="Noto Sans" font-size="20" letter-spacing="0em"><tspan x="150" y="272.26">TokenID : ',
            Strings.toString(_tokenId),
            "</tspan></text>",
            '<text fill="#130912" xml:space="preserve" style="white-space: pre" font-family="Noto Sans" font-size="36" letter-spacing="0em"><tspan x="149" y="121.468">',
            name(),
            "</tspan>"
        );

        if (isClaimed) {
            svg = string.concat(
                svg,
                '<rect y="322" width="400" height="34" fill="#D9D9D9"/>',
                '<text fill="#130912" xml:space="preserve" style="white-space: pre" font-family="Inter" font-size="16" letter-spacing="0em"><tspan x="159" y="344.318">Redeemed</tspan></text>'
            );
        }

        svg = string.concat(
            svg,
            "<defs>",
            '<linearGradient id="paint0_linear_1734_831" x1="-62.5" y1="-57" x2="414" y2="422" gradientUnits="userSpaceOnUse">',
            '<stop stop-color="#8386FD"/>',
            '<stop offset="1" stop-color="#E192A7"/>',
            "</linearGradient>",
            "</defs>",
            "</svg>"
        );

        return svg;
    }
}
