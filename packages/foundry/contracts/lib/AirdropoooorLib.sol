//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* ######################################################################### */
/*                          library: AirdropoooorLib                         */
/* ######################################################################### */
library AirdropoooorLib {
    struct TbaToAirdrop {
        address toAddress;
        address tbaAddress;
        uint256 amount;
        bool isClaimed;
        bool isWithdrawn;
    }

    enum AirdropStatus {
        UNCLAIMED,
        CLAIMED
    }
}
