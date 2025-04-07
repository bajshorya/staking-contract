// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BarcaCoin.sol";
import "../src/StakingContract.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        StakingContract staking = new StakingContract(address(0)); // temp zero address
        BarcaCoinContract orca = new BarcaCoinContract(address(staking));
        staking = new StakingContract(address(orca));
        orca.updateStakingContract(address(staking)); // link the correct one

        vm.stopBroadcast();
    }
}
