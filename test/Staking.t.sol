// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakingContract.sol";
import "../src/OrcaCoin.sol";

contract StakingContractTest is Test {
    StakingContract stakingContract;
    OrcaCoinContract orcaToken;
    address testUser = 0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88;

    function setUp() public {
        orcaToken = new OrcaCoinContract(address(this));
        stakingContract = new StakingContract(address(orcaToken));
        orcaToken.updateStakingContract(address(stakingContract));
    }

    function testStake() public {
        stakingContract.stake{value: 200}();
        assertEq(stakingContract.balanceOf(address(this)), 200);
    }

    function testStakeUser() public {
        vm.startPrank(testUser);
        vm.deal(testUser, 10 ether);
        stakingContract.stake{value: 1 ether}();
        assertEq(stakingContract.balanceOf(testUser), 1 ether);
        vm.stopPrank();
    }

    function testUnStake() public {
        stakingContract.stake{value: 200}();
        stakingContract.unstake(100);
        assertEq(stakingContract.balanceOf(address(this)), 100);
    }

    function testFailUnStake() public {
        stakingContract.stake{value: 200}();
        stakingContract.unstake(300);
    }

    function testClaimRewards() public {
        stakingContract.stake{value: 1 ether}();
        vm.warp(block.timestamp + 10);
        uint reward = stakingContract.getReward(address(this));
        assertGt(reward, 0);

        stakingContract.claimRewards();
        assertEq(stakingContract.getReward(address(this)), 0);
        assertGt(orcaToken.balanceOf(address(this)), 0);
    }

    function testMultipleStakes() public {
        stakingContract.stake{value: 1 ether}();
        vm.warp(block.timestamp + 5);
        stakingContract.stake{value: 2 ether}();
        assertEq(stakingContract.balanceOf(address(this)), 3 ether);
    }
}