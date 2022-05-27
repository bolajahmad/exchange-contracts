// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Wallet {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner is allowed");
        _;
    }

    function approve(
        IERC20 asset,
        address contract_,
        bool enable
    ) external onlyOwner {
        if (enable) {
            IERC20(asset).approve(contract_, type(uint256).max - 1);
        } else {
            IERC20(asset).approve(contract_, 0);
        }
    }
}