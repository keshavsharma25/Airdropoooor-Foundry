//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
  constructor() ERC20("MockERC20", "M20") {}

  function mint(address user, uint256 amount) public {
    _mint(user, amount);
  }
}
