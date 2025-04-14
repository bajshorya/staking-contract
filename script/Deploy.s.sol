// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/BarcaCoin.sol";
import "../src/StakingContract.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY")); // Start broadcasting transactions

        // Deploy BarcaCoinContract first
        BarcaCoinContract barcaCoin = new BarcaCoinContract(address(0)); // Initial staking contract address is 0, will be updated later

        // Deploy StakingContract, passing the BarcaCoin address
        StakingContract stakingContract = new StakingContract(address(barcaCoin));

        // Update the staking contract address in BarcaCoinContract
        barcaCoin.updateStakingContract(address(stakingContract));

        vm.stopBroadcast(); // Stop broadcasting

        // Log the deployed addresses
        console.log("BarcaCoinContract deployed at:", address(barcaCoin));
        console.log("StakingContract deployed at:", address(stakingContract));
    }
}