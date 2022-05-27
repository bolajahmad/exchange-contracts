// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Wallet.sol";

contract MarketToken is Ownable {
    using Counters for Counter.Counters;
    using SafeMath for uint256;

    enum Answer {
        NONE,
        TRUE,
        FALSE
    }
    enum MarketStatus {
        OPEN,
        PAUSE,
        CLOSED
    }

    struct Stake {
        uint256 timestamp;
        uint256 amount;
        address staker;
        Answer bet;
    }
}