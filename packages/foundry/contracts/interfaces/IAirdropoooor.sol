// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAirdropoooor {
    error ApprovalCallerNotOwnerNorApproved();
    error ApprovalQueryForNonexistentToken();
    error BalanceQueryForZeroAddress();
    error MintERC2309QuantityExceedsLimit();
    error MintToZeroAddress();
    error MintZeroQuantity();
    error NotCompatibleWithSpotMints();
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error OwnerQueryForNonexistentToken();
    error OwnershipNotInitializedForExtraData();
    error SequentialMintExceedsLimit();
    error SequentialUpToTooSmall();
    error SetUserCallerNotOwnerNorApproved();
    error SpotMintTokenIdTooSmall();
    error TokenAlreadyExists();
    error TransferCallerNotOwnerNorApproved();
    error TransferFromIncorrectOwner();
    error TransferToNonERC721ReceiverImplementer();
    error TransferToZeroAddress();
    error URIQueryForNonexistentToken();

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event ConsecutiveTransfer(
        uint256 indexed fromTokenId,
        uint256 toTokenId,
        address indexed from,
        address indexed to
    );
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event UpdateUser(
        uint256 indexed tokenId,
        address indexed user,
        uint64 expires
    );

    function MAINTAINER_ADDRESS() external view returns (address);
    function approve(address to, uint256 tokenId) external payable;
    function balanceOf(address owner) external view returns (uint256);
    function burn(uint256 _tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address);
    function getTenantTokenId(address _user) external view returns (int256);
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
    function name() external view returns (string memory);
    function owner() external view returns (address);
    function ownerOf(uint256 tokenId) external view returns (address);
    function renounceOwnership() external;
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) external payable;
    function setApprovalForAll(address operator, bool approved) external;
    function setUser(uint256 tokenId, address user, uint64 expires) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
    function totalSupply() external view returns (uint256 result);
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;
    function transferOwnership(address newOwner) external;
    function userExpires(uint256 tokenId) external view returns (uint256);
    function userOf(uint256 tokenId) external view returns (address);
}
