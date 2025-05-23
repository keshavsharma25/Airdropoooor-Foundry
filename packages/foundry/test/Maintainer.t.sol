//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import { AirdropoooorLib as adl } from "../contracts/lib/AirdropoooorLib.sol";
import { Maintainer } from "../contracts/Maintainer.sol";
import { Registry } from "../contracts/Registry.sol";
import { AirdropoooorFactory } from "../contracts/AirdropoooorFactory.sol";
import { Airdropoooor } from "../contracts/Airdropoooor.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { MockERC20 } from "./mock/MockERC20.sol";

contract AidropoooorFactoryFixture is Test {
    Registry public registry;
    AirdropoooorFactory public airdropoooorFactory;
    MockERC20 public mock20;

    Maintainer public maintainer;
    Airdropoooor public airdrop;

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

    function setUp() public virtual {
        vm.startPrank(admin);

        mock20 = new MockERC20();
        mock20.mint(admin, 1000 ether);

        registry = new Registry();
        airdropoooorFactory = new AirdropoooorFactory(admin, address(registry));

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

        (address _airdrop, address _maintainer) = airdropoooorFactory
            .getContractsInfo(0);

        airdrop = Airdropoooor(_airdrop);
        maintainer = Maintainer(payable(_maintainer));
    }
}

contract MaintainerInitialTest is AidropoooorFactoryFixture {
    function setUp() public virtual override {
        super.setUp();
    }

    function test_constructor() public view {
        adl.TbaToAirdrop memory tbaInfo = maintainer.getAirdropInfo(0);
        assertEq(tbaInfo.toAddress, addresses[0]);
        assertEq(tbaInfo.amount, amounts[0]);
    }

    function test_depositTotalAirdropAmount() public {
        vm.startPrank(admin);
        uint256 amount = maintainer.totalAirdropAmount();
        mock20.approve(address(maintainer), amount);
        maintainer.depositTotalAirdropAmount();
        vm.stopPrank();

        assertEq(
            mock20.balanceOf(address(maintainer)),
            maintainer.totalAirdropAmount()
        );
    }

    function test_fundAirdropInTBAs() public {
        vm.startPrank(admin);
        // approve and deposit in Maintainer Contract
        uint256 amount = maintainer.totalAirdropAmount();
        mock20.approve(address(maintainer), amount);
        maintainer.depositTotalAirdropAmount();

        assertEq(mock20.balanceOf(address(maintainer)), amount);
        // fund ERC20 Tokens in TBA Accounts
        maintainer.fundAirdropInTBAs();
        vm.stopPrank();

        // assert maintainer balance should be Zero
        assertEq(mock20.balanceOf(address(maintainer)), 0);

        // assert TBA balance
        address tba = maintainer.getTBA(0);
        uint256 balance = maintainer.getAirdropAmount(0);
        assertEq(mock20.balanceOf(tba), balance);
    }

    function testFail_withdrawFromTBAs() public {}

    function test_withdrawFromTBAs() public {}
}
