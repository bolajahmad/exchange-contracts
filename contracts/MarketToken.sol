// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./Wallet.sol";

contract MarketToken is Ownable {
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    event BetPlaced(address indexed sender, Answer betPlaced, uint256 amountBet);

    enum Answer { NONE, TRUE, FALSE }
    enum MarketStatus { OPEN, PAUSE, CLOSED }

    struct Stake {
        uint256 timestamp;
        uint256 amount;
        address staker;
        Answer bet;
    }

    Counters.Counter private _trueCounter;
    Counters.Counter private _falseCounter;

    mapping(Answer => mapping(address => Stake)) public stakes;
    mapping(Answer => Wallet) public escrow;

    IERC20 public _DAI;
    address public _oracle;
    address private _feeCollector;

    MarketStatus status;
    Answer public bet;
    Answer public wrongBet;
    bool public hasApproved;

    constructor (address oracle, address feeCollector, IERC20 dai) {
        _DAI = dai;
        _feeCollector = feeCollector;
        _oracle = oracle;
    }

    function setFeeCollector(address collector) external {
        _feeCollector = collector;
    }

    function setOracle(address oracle) external {
        _oracle = oracle;
    }

    function grantWalletApproval() external onlyOwner {
        require(!hasApproved, "Wallets spending is already approved");

        escrow[Answer.TRUE] = new Wallet(address(this));
        escrow[Answer.FALSE] = new Wallet(address(this));

        // this approve method is different from IERC20/ERC20 approve
        // Refer to "./Wallet.sol" for definition
        escrow[Answer.TRUE].approve(_DAI, address(this), true);
        escrow[Answer.FALSE].approve(_DAI, address(this), true);
    }

    function enter(uint256 amount, Answer _bet) external {
        require(status == MarketStatus.OPEN, "Market is not open");
        require(_bet != Answer.NONE, "Please select a valid answer");
        require(amount >= 10, "Minimum amount = 10 DAI");

        // save the stake to memory
        Stake memory stake = stakes[_bet][msg.sender];

        if (stake.bet == Answer.NONE) {
            stake = Stake({
                staker: msg.sender,
                bet: _bet,
                timestamp: block.timestamp,
                amount: amount
            });
        } else {
            stake.amount += amount;
        }

        if (stake.bet == Answer.TRUE) {
            _trueCounter.increment();
        } else {
            _falseCounter.increment();
        }

        uint256 feepct = 5;
        uint256 position = (amount * feepct) / 100;
        uint256 owed = (amount - position);
        _DAI.transferFrom(msg.sender, _feeCollector, position);
        _DAI.transferFrom(msg.sender, address(escrow[Answer.TRUE]), owed);

        stakes[_bet][msg.sender] = stake;

        emit BetPlaced(msg.sender, stake.bet, stake.amount);
    }
}