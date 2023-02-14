// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public stakingToken;
    IERC20 public rewardToken;
    mapping(address => uint256) public staked;
    mapping(address => uint256) private stakingTime;

    constructor(address _stakeToken, address _rewardToken) {
        stakingToken = IERC20(_stakeToken);
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

    function unStake(uint256 _amount) external {
        require(staked[msg.sender] >= _amount, "insuffient Tokens");
        require(_amount > 0, " token amount is invalid");
        require(
            stakingToken.allowance(
                0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
                address(this)
            ) > _amount,
            "Low Allowance"
        );
        claim();
        staked[msg.sender] -= _amount;
        stakingToken.transferFrom(
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
            msg.sender,
            _amount
        );
    }

    function claim() public {
        require(staked[msg.sender] > 0, "insufficient tokens");
        require(
            block.timestamp > stakingTime[msg.sender] + 5,
            "can't claim now"
        );
        uint256 amountStaked = staked[msg.sender];
        uint256 secondsStaked = block.timestamp - stakingTime[msg.sender];
        uint256 rewards = amountStaked * (secondsStaked / 3.154e7);
        require(
            rewardToken.allowance(
                0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
                address(this)
            ) > rewards,
            "Low Allowance"
        );
        rewardToken.transferFrom(
            0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
            msg.sender,
            rewards
        );
        stakingTime[msg.sender] = block.timestamp;
    }

    function RewardBalance() external view returns (uint256) {
        return
            rewardToken.allowance(
                0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
                address(this)
            );
    }

    function StakeBalance() external view returns (uint256) {
        return
            stakingToken.allowance(
                0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
                address(this)
            );
    }
}
