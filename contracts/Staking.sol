// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Staking is ReentrancyGuard {
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    
    uint256 public constant Reward= 5;
    uint256 public totalSupply;
    uint256 public stakingTime;
    //mapping from address to staked amount
    mapping(address => uint256) public staked_balance;
    // mapping from address to the possible rewards
    mapping(address => uint256) public rewards;
    
	constructor(address _stakingToken, address _rewardToken) {
         stakingToken = IERC20(_stakingToken);
         rewardToken  = IERC20(_rewardToken);
    }

    function earned(address account) public view returns (uint256) {
        uint256 currentBalance = staked_balance[account];
        uint256 currentRewardPerToken = CalculateRewardPerToken();
        uint256 earnedReward = ((currentBalance * currentRewardPerToken) / 1e18);

        return earnedReward;
    }

	function getStakedBalance(address account) public view returns (uint256) {
        return staked_balance[account];
    }

   
    function CalculateRewardPerToken() public view returns (uint256) {
        if (staked_balance[msg.sender] == 0) {
            return 0;
        } else {
            return
                (((block.timestamp - stakingTime) * Reward* 1e18) / totalSupply);
        }
    }

    function stake(uint256 amount) external {
        require(staked_balance[msg.sender]==0, "Already Staked");
        totalSupply += amount;
		stakingTime = block.timestamp;
		staked_balance[msg.sender] += amount;
		rewards[msg.sender] = earned(msg.sender);
		uint currentBalance = staked_balance[msg.sender];
        bool success = stakingToken.transferFrom(msg.sender, address(this), currentBalance);
        require(success, "Transfer Failed"); 
    
    }

    function withdraw(uint256 amount) external {
		require(stakingTime + 7 days < block.timestamp, "You can't withdraw Now");
		require(address(this).balance > amount, "Contract has Less Tokens");
		require(amount == staked_balance[msg.sender], "You have unsuffient Tokens");
        staked_balance[msg.sender] -= amount;
        totalSupply -= amount;
		claimReward();
        bool success = stakingToken.transfer(msg.sender, amount);
        require(success,"Withdraw Failed");
    }

    function claimReward() private {
        uint256 reward = rewards[msg.sender];
		rewards[msg.sender]=0;
        bool success = rewardToken.transfer(msg.sender, reward);
        require(success, "ClaimReward is Failed");
    }

}
