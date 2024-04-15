//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library AirdropoooorLib {
    struct ToAirdrop {
        address toAddress;
        uint256 amount;
    }

    struct tbaToAirdrop {
        address toaddress;
        address tbaAddress;
        uint256 amount;
    }

    enum AirdropStatus {
        PENDING,
        UNCLAIMED,
        CLAIMED
    }
}
