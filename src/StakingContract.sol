// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./BarcaCoin.sol";

contract StakingContract {
    mapping(address => uint) public balances;
    mapping(address => uint) public unclaimedRewards;
    mapping(address => uint) public lastUpdatedTime;
    
    BarcaCoinContract public barcaToken;
    uint public rewardRate = 1e18; // 1 Barca per second per ether staked

    constructor(address _barcaToken) {
        barcaToken = BarcaCoinContract(_barcaToken);
    }

    function stake() public payable {
        require(msg.value > 0, "Cannot stake 0 ETH");

        if (lastUpdatedTime[msg.sender] == 0) {
            lastUpdatedTime[msg.sender] = block.timestamp;
        } else {
            unclaimedRewards[msg.sender] += _calculateRewards(msg.sender);
            lastUpdatedTime[msg.sender] = block.timestamp;
        }
        
        balances[msg.sender] += msg.value;
    }

    function unstake(uint _amount) public {
        require(_amount <= balances[msg.sender], "Insufficient balance");
        
        unclaimedRewards[msg.sender] += _calculateRewards(msg.sender);
        lastUpdatedTime[msg.sender] = block.timestamp;
        
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function _calculateRewards(address _address) internal view returns (uint) {
        uint timeElapsed = block.timestamp - lastUpdatedTime[_address];
        return (timeElapsed * balances[_address] * rewardRate) / 1 ether;
    }

    function getReward(address _address) public view returns (uint) {
        return unclaimedRewards[_address] + _calculateRewards(_address);
    }

    function claimRewards() public {
        uint rewardAmount = getReward(msg.sender);
        require(rewardAmount > 0, "No rewards to claim");

        unclaimedRewards[msg.sender] = 0;
        lastUpdatedTime[msg.sender] = block.timestamp;
        
        barcaToken.mint(msg.sender, rewardAmount);
    }

    function balanceOf(address _address) public view returns (uint) {
        return balances[_address];
    }
}
