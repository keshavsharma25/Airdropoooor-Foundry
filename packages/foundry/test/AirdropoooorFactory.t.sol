//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import { AirdropoooorFactory } from "../contracts/AirdropoooorFactory.sol";
import { Registry } from "../contracts/Registry.sol";
import { MockERC20 } from "./mock/MockERC20.sol";
import { AirdropoooorLib as adl } from "../contracts/lib/AirdropoooorLib.sol";

contract AirDropoooorFactoryTest is Test {
    event CreateAirdropoooor(
        address indexed airdropoooor,
        address maintainer,
        address tokenAddress
    );

    Registry public registry;
    AirdropoooorFactory public airdropoooorFactory;
    MockERC20 public mock20;

    address public admin = vm.addr(0x5420);
    address public user = vm.addr(0x5421);

    adl.ToAirdrop[] public airdropInfo = [
        adl.ToAirdrop({ toAddress: vm.addr(0x01), amount: 10 ether }),
        adl.ToAirdrop({ toAddress: vm.addr(0x02), amount: 10 ether })
    ];

    function setUp() public {
        vm.startPrank(admin);

        registry = new Registry();
        airdropoooorFactory = new AirdropoooorFactory(admin, address(registry));
        mock20 = new MockERC20();

        vm.stopPrank();
    }

    function test_createAirdropoooor() public {
        vm.startPrank(user);

        vm.expectEmit(true, false, false, true);

        emit CreateAirdropoooor(
            0x5E9134F4E045fF525d848CAcD684Fe93d51EaDC3,
            0x489871e6F8F77eb2B190d270AD65f4D1B44C92A3,
            address(mock20)
        );

        airdropoooorFactory.createAirdropoooor(
            "smth",
            "SMTH",
            address(mock20),
            admin,
            airdropInfo,
            vm.getBlockTimestamp() + 100
        );

        assertEq(airdropoooorFactory.getNoAirdropoooors(), 1);

        vm.stopPrank();
    }

    function test_getIdsByOwner() public {
        vm.startPrank(user);

        airdropoooorFactory.createAirdropoooor(
            "smth",
            "SMTH",
            address(mock20),
            admin,
            airdropInfo,
            vm.getBlockTimestamp() + 100
        );

        vm.stopPrank();

        uint256[] memory _tokenIds = airdropoooorFactory.getIdsByOwner(admin);
        assertEq(_tokenIds[0], 0);
    }
}
