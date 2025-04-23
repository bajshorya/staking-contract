// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol"; // Added import for console.log
import {BarcaCoinContract} from "../src/BarcaCoin.sol";
import {StakingContract} from "../src/StakingContract.sol";

contract DeployScript is Script {
    function run() external {
        // Load private key from environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy BarcaCoinContract with zero address for staking contract
        BarcaCoinContract barcaCoin = new BarcaCoinContract(address(0));
        console.log("BarcaCoinContract deployed at:", address(barcaCoin));

        // Deploy StakingContract with BarcaCoinContract address
        StakingContract stakingContract = new StakingContract(address(barcaCoin));
        console.log("StakingContract deployed at:", address(stakingContract));

        // Update stakingContract address in BarcaCoinContract
        barcaCoin.updateStakingContract(address(stakingContract));
        console.log("Updated BarcaCoinContract.stakingContract to:", address(stakingContract));

        // Stop broadcasting
        vm.stopBroadcast();
    }
}