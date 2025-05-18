//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import { AirdropoooorFactory } from "../contracts/AirdropoooorFactory.sol";
import { Registry } from "../contracts/Registry.sol";
import { MockERC20 } from "./mock/MockERC20.sol";
import { AirdropoooorLib as adl } from "../contracts/lib/AirdropoooorLib.sol";

contract AirDropoooorFactoryTest is Test {
    Registry public registry;
    AirdropoooorFactory public airdropoooorFactory;
    MockERC20 public mock20;

    address public admin = vm.addr(0x5420);
    address public user = vm.addr(0x5421);

    address[] public addresses = [
        vm.addr(0x1000),
        vm.addr(0x1001),
        vm.addr(0x1003),
        vm.addr(0x1004),
        vm.addr(0x1005)
    ];

    uint256[] public amounts = [1000, 1001, 1004, 1005, 1005];

    function setUp() public {
        vm.startPrank(admin);

        registry = new Registry();
        airdropoooorFactory = new AirdropoooorFactory(admin, address(registry));
        mock20 = new MockERC20();

        airdropoooorFactory.createAirdropoooor(
            "smth",
            "SMTH",
            address(mock20),
            admin,
            addresses,
            amounts,
            vm.getBlockTimestamp() + 100
        );

        vm.stopPrank();
    }

    function test_createAirdropoooor() public view {
        assertEq(airdropoooorFactory.getNoAirdropoooors(), 1);
    }

    function test_getIdsByOwner() public {
        vm.startPrank(user);

        vm.stopPrank();

        uint256[] memory _tokenIds = airdropoooorFactory.getIdsByOwner(admin);
        assertEq(_tokenIds[0], 0);
    }
}
