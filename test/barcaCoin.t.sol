// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/BarcaCoin.sol";
contract BarcaCoinContractTest is Test {
    BarcaCoinContract public barcaCoin;
    address public owner;
    address public stakingContract;
    address public user1;
    address public user2;
    uint256 public constant MAX_SUPPLY = 10_000_000 * 10**18; // 10 million tokens
    string public constant NAME = "Barca";
    string public constant SYMBOL = "BAR";
    uint8 public constant DECIMALS = 18;
    string public constant TOKEN_URI = "https://barcacoin.com/metadata.json";

    // Events for testing
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Set up the test environment before each test
    function setUp() public {
        owner = address(this); // Test contract is the owner
        stakingContract = address(0x123);
        user1 = address(0x456);
        user2 = address(0x789);

        // Deploy BarcaCoinContract with stakingContract
        barcaCoin = new BarcaCoinContract(stakingContract);
    }

    // Test deployment and initial state
    function test_Deployment() public {
        assertEq(barcaCoin.name(), NAME, "Incorrect name");
        assertEq(barcaCoin.symbol(), SYMBOL, "Incorrect symbol");
        assertEq(barcaCoin.decimals(), DECIMALS, "Incorrect decimals");
        assertEq(barcaCoin.maxSupply(), MAX_SUPPLY, "Incorrect maxSupply");
        assertEq(barcaCoin.stakingContract(), stakingContract, "Incorrect stakingContract");
        assertEq(barcaCoin.owner(), address(this), "Incorrect owner");
        assertEq(barcaCoin.totalSupply(), 0, "Initial totalSupply should be 0");
        assertEq(barcaCoin.tokenURI(), TOKEN_URI, "Incorrect tokenURI");
    }

    // Test minting by stakingContract within maxSupply
    function test_Mint_Success() public {
        uint256 amount = 1_000 * 10**18; // 1,000 tokens
        vm.prank(stakingContract);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), user1, amount);
        barcaCoin.mint(user1, amount);

        assertEq(barcaCoin.balanceOf(user1), amount, "Incorrect user1 balance");
        assertEq(barcaCoin.totalSupply(), amount, "Incorrect totalSupply");
    }

    // Test minting by non-stakingContract fails
    function test_Mint_Fail_NonStakingContract() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(user1);
        vm.expectRevert("Only staking contract can mint");
        barcaCoin.mint(user1, amount);
    }

    // Test minting exceeding maxSupply fails
    function test_Mint_Fail_ExceedsMaxSupply() public {
        uint256 amount = MAX_SUPPLY + 1;
        vm.prank(stakingContract);
        vm.expectRevert("Exceeds maximum supply");
        barcaCoin.mint(user1, amount);
    }

    // Test minting exactly maxSupply
    function test_Mint_ExactlyMaxSupply() public {
        vm.prank(stakingContract);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), user1, MAX_SUPPLY);
        barcaCoin.mint(user1, MAX_SUPPLY);

        assertEq(barcaCoin.balanceOf(user1), MAX_SUPPLY, "Incorrect user1 balance");
        assertEq(barcaCoin.totalSupply(), MAX_SUPPLY, "Incorrect totalSupply");
    }

    // Test minting zero amount
    function test_Mint_ZeroAmount() public {
        vm.prank(stakingContract);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), user1, 0);
        barcaCoin.mint(user1, 0);

        assertEq(barcaCoin.balanceOf(user1), 0, "Incorrect user1 balance");
        assertEq(barcaCoin.totalSupply(), 0, "Incorrect totalSupply");
    }

    // Test updateStakingContract by owner
    function test_UpdateStakingContract_Success() public {
        address newStakingContract = address(0xABC);
        vm.prank(owner);
        barcaCoin.updateStakingContract(newStakingContract);

        assertEq(barcaCoin.stakingContract(), newStakingContract, "Incorrect new stakingContract");
    }

    // Test updateStakingContract by non-owner fails
    function test_UpdateStakingContract_Fail_NonOwner() public {
        address newStakingContract = address(0xABC);
        vm.prank(user1);
        vm.expectRevert("Only owner can update staking contract");
        barcaCoin.updateStakingContract(newStakingContract);
    }

    // Test ERC20 transfer
    function test_Transfer_Success() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(stakingContract);
        barcaCoin.mint(user1, amount);

        vm.prank(user1);
        vm.expectEmit(true, true, false, true);
        emit Transfer(user1, user2, amount / 2);
        barcaCoin.transfer(user2, amount / 2);

        assertEq(barcaCoin.balanceOf(user1), amount / 2, "Incorrect user1 balance");
        assertEq(barcaCoin.balanceOf(user2), amount / 2, "Incorrect user2 balance");
        assertEq(barcaCoin.totalSupply(), amount, "Incorrect totalSupply");
    }

    

    // Test approve and allowance
    function test_Approve_Success() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(user1);
        vm.expectEmit(true, true, false, true);
        emit Approval(user1, user2, amount);
        barcaCoin.approve(user2, amount);

        assertEq(barcaCoin.allowance(user1, user2), amount, "Incorrect allowance");
    }

    // Test transferFrom
    function test_TransferFrom_Success() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(stakingContract);
        barcaCoin.mint(user1, amount);

        vm.prank(user1);
        barcaCoin.approve(user2, amount / 2);

        vm.prank(user2);
        vm.expectEmit(true, true, false, true);
        emit Transfer(user1, user2, amount / 2);
        barcaCoin.transferFrom(user1, user2, amount / 2);

        assertEq(barcaCoin.balanceOf(user1), amount / 2, "Incorrect user1 balance");
        assertEq(barcaCoin.balanceOf(user2), amount / 2, "Incorrect user2 balance");
        assertEq(barcaCoin.allowance(user1, user2), 0, "Incorrect allowance");
        assertEq(barcaCoin.totalSupply(), amount, "Incorrect totalSupply");
    }

  

    // Test balanceOf
    function test_BalanceOf() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(stakingContract);
        barcaCoin.mint(user1, amount);

        assertEq(barcaCoin.balanceOf(user1), amount, "Incorrect user1 balance");
        assertEq(barcaCoin.balanceOf(user2), 0, "Incorrect user2 balance");
    }

    // Test totalSupply
    function test_TotalSupply() public {
        uint256 amount = 1_000 * 10**18;
        vm.prank(stakingContract);
        barcaCoin.mint(user1, amount);

        assertEq(barcaCoin.totalSupply(), amount, "Incorrect totalSupply");
    }

    // Test tokenURI
    function test_TokenURI() public {
        assertEq(barcaCoin.tokenURI(), TOKEN_URI, "Incorrect tokenURI");
    }
}