//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* ######################################################################### */
/*                          library: AirdropoooorLib                         */
/* ######################################################################### */
library AirdropoooorLib {
    struct ToAirdrop {
        address toAddress;
        uint256 amount;
    }

    struct TbaToAirdrop {
        address toAddress;
        address tbaAddress;
        uint256 amount;
        bool isClaimed;
        bool isWithdrawn;
    }

    enum AirdropStatus {
        PENDING,
        UNCLAIMED,
        CLAIMED
    }
}
