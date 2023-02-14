// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public stakingToken;
    IERC20 public rewardToken;

    uint256 public constant Reward = 5;
    uint256 public totalSupply;
    uint256 public staingTime;
    //mapping from address to staked amount
    mapping(address => uint256) public staked_balance;
    // mapping from address to the possible rewards
    mapping(address => uint256) public rewards;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stakeTokens(uint256 _amount) external {
        require(_amount > 0, "Invalid no. Of Tokens");
        require(
            stakingToken.balanceOf(msg.sender) >= _amount,
            "Insufficient Tokens"
        );
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        if (staked[msg.sender] > 0) {
            claim();
        }
        stakingTime[msg.sender] = block.timestamp;
        staked[msg.sender] += _amount;
    }

    function CalculateRewardPerToken() public view returns (uint256) {
        if (staked_balance[msg.sender] == 0) {
            return 0;
        } else {
            return (((block.timestamp - staingTime) * Reward * 1e18) /
                totalSupply);
        }
    }

    function stake(uint256 amount) external {
        require(staked_balance[msg.sender] == 0, "Already Staked");
        totalSupply += amount;
        staingTime = block.timestamp;
        staked_balance[msg.sender] += amount;
        rewards[msg.sender] = earned(msg.sender);
        uint256 currentBalance = staked_balance[msg.sender];
        bool success = stakingToken.transferFrom(
            msg.sender,
            address(this),
            currentBalance
        );
        require(success, "Transfer Failed");
    }

    function withdraw(uint256 amount) external {
        require(
            staingTime + 7 days < block.timestamp,
            "You can't withdraw Now"
        );
        require(address(this).balance > amount, "Contract has Less Tokens");
        require(
            amount == staked_balance[msg.sender],
            "You have unsuffient Tokens"
        );
        staked_balance[msg.sender] -= amount;
        totalSupply -= amount;
        claimReward();
        bool success = stakingToken.transfer(msg.sender, amount);
        require(success, "Withdraw Failed");
    }

    function StakeBalance() external view returns (uint256) {
        return
            stakingToken.allowance(
                0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
                address(this)
            );
    }
}
