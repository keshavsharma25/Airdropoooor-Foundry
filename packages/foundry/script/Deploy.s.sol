//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DeployHelpers.s.sol";
import {ERC6551Registry} from "erc6551/ERC6551Registry.sol";
import {AirdropoooorFactory} from "../contracts/AirdropoooorFactory.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);

        ERC6551Registry registry = new ERC6551Registry();
        AirdropoooorFactory factory = new AirdropoooorFactory(
            vm.addr(deployerPrivateKey),
            address(registry)
        );

        console.logString(
            string.concat(
                "The Registry Address is: ",
                vm.toString(address(registry))
            )
        );

        console.logString(
            string.concat(
                "The AirdropooooorFactory Address is: ",
                vm.toString(address(factory))
            )
        );

        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
