/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  31337: {
    ERC6551Registry: {
      address: "0xabebe9a2d62af9a89e86eb208b51321e748640c3",
      abi: [
        {
          type: "function",
          name: "account",
          inputs: [
            {
              name: "implementation",
              type: "address",
              internalType: "address",
            },
            {
              name: "salt",
              type: "bytes32",
              internalType: "bytes32",
            },
            {
              name: "chainId",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "tokenContract",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "createAccount",
          inputs: [
            {
              name: "implementation",
              type: "address",
              internalType: "address",
            },
            {
              name: "salt",
              type: "bytes32",
              internalType: "bytes32",
            },
            {
              name: "chainId",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "tokenContract",
              type: "address",
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "event",
          name: "ERC6551AccountCreated",
          inputs: [
            {
              name: "account",
              type: "address",
              indexed: false,
              internalType: "address",
            },
            {
              name: "implementation",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "salt",
              type: "bytes32",
              indexed: false,
              internalType: "bytes32",
            },
            {
              name: "chainId",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "tokenContract",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "tokenId",
              type: "uint256",
              indexed: true,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "AccountCreationFailed",
          inputs: [],
        },
      ],
      inheritedFunctions: {
        account: "lib/erc6551/src/interfaces/IERC6551Registry.sol",
        createAccount: "lib/erc6551/src/interfaces/IERC6551Registry.sol",
      },
    },
    AirdropoooorFactory: {
      address: "0xf42ec71a4440f5e9871c643696dd6dc9a38911f8",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_owner",
              type: "address",
              internalType: "address",
            },
            {
              name: "_registry",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "fallback",
          stateMutability: "payable",
        },
        {
          type: "receive",
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "REGISTRY_ADDRESS",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "createAirdropoooor",
          inputs: [
            {
              name: "_name",
              type: "string",
              internalType: "string",
            },
            {
              name: "_symbol",
              type: "string",
              internalType: "string",
            },
            {
              name: "_airdropTokenAddr",
              type: "address",
              internalType: "address",
            },
            {
              name: "_admin",
              type: "address",
              internalType: "address",
            },
            {
              name: "_airdropAddresses",
              type: "address[]",
              internalType: "address[]",
            },
            {
              name: "_airdropAmounts",
              type: "uint256[]",
              internalType: "uint256[]",
            },
            {
              name: "_deadlineTimestamp",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "getContractsInfo",
          inputs: [
            {
              name: "id",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getIdsByOwner",
          inputs: [
            {
              name: "owner",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256[]",
              internalType: "uint256[]",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getNoAirdropoooors",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getRentedTokensForUser",
          inputs: [
            {
              name: "user",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "int256[]",
              internalType: "int256[]",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "owner",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "renounceOwnership",
          inputs: [],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "transferOwnership",
          inputs: [
            {
              name: "newOwner",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "event",
          name: "CreateAirdropoooor",
          inputs: [
            {
              name: "airdropoooor",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "maintainer",
              type: "address",
              indexed: false,
              internalType: "address",
            },
            {
              name: "tokenAddress",
              type: "address",
              indexed: false,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "OwnershipTransferred",
          inputs: [
            {
              name: "previousOwner",
              type: "address",
              indexed: true,
              internalType: "address",
            },
            {
              name: "newOwner",
              type: "address",
              indexed: true,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "OwnableInvalidOwner",
          inputs: [
            {
              name: "owner",
              type: "address",
              internalType: "address",
            },
          ],
        },
        {
          type: "error",
          name: "OwnableUnauthorizedAccount",
          inputs: [
            {
              name: "account",
              type: "address",
              internalType: "address",
            },
          ],
        },
      ],
      inheritedFunctions: {
        owner: "lib/openzeppelin-contracts/contracts/access/Ownable.sol",
        renounceOwnership: "lib/openzeppelin-contracts/contracts/access/Ownable.sol",
        transferOwnership: "lib/openzeppelin-contracts/contracts/access/Ownable.sol",
      },
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
