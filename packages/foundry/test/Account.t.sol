//SPDX-License-Identifier: minutes
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

import { Maintainer } from "../contracts/Maintainer.sol";
import { Registry } from "../contracts/Registry.sol";
import { Account } from "../contracts/Account.sol";
import { IAccount } from "../contracts/interfaces/IAccount.sol";
import { AirdropoooorFactory } from "../contracts/AirdropoooorFactory.sol";
import { Airdropoooor } from "../contracts/Airdropoooor.sol";
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

contract AccountTest is AidropoooorFactoryFixture {
    IAccount public account;

    function setUp() public virtual override {
        super.setUp();

        address tba = maintainer.getTBA(0);
        account = IAccount(payable(tba));
    }

    function test_token() public view {
        (uint256 chainId, address tokenContract, uint256 tokenId) = account
            .token();

        assertEq(chainId, block.chainid);
        assertEq(tokenContract, address(airdrop));
        assertEq(tokenId, 0);
    }

    function test_getOwner() public view {
        /* address maintainerAddr = address(maintainer);
        console.log("Maintainer Address: ", maintainerAddr);
        console.log("Token Owner Address: ", account.owner());

        assertEq(account.owner(), maintainerAddr); */
    }

    function test_getUser() public {}

    function test_redeemBeforeDeadlineAsUser() public {}

    function testFail_redeemAfterDeadlineAsUser() public {}

    function testFail_redeemBeforeDeadlineAsOwner() public {}

    function testFail_redeemAfterDeadlineAsOwner() public {}

    function test_withdrawAfterDeadlineAsOwner() public {}

    function testFail_withdrawBeforeDeadlineAsOwner() public {}

    function testFail_setAirdropTokenAddress() public {}
}
