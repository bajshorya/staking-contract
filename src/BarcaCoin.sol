// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface ERC20Interface {
    function mint(address account, uint256 value) external;
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function totalSupply() external view returns (uint256);
}

contract BarcaCoinContract is ERC20, ERC20Interface {
    address public stakingContract;
    address public owner;
    uint256 public maxSupply = 10_000_000 * 10**18; // 10 million BarcaCoins

    constructor(address _stakingContract) ERC20("Barca", "BAR") {
        stakingContract = _stakingContract;
        owner = msg.sender;
    }

    function mint(address account, uint256 value) public override {
        require(msg.sender == stakingContract, "Only staking contract can mint");
        require(totalSupply() + value <= maxSupply, "Exceeds maximum supply");
        _mint(account, value);
    }

    function updateStakingContract(address _stakingContract) public {
        require(msg.sender == owner, "Only owner can update staking contract");
        stakingContract = _stakingContract;
    }

    function tokenURI() public pure returns (string memory) {
        return "https://ipfs.io/ipfs/bafkreibb5sdaqnakexzaumhiehl6l67jz7bdsplsuoojxuspl77klyexlq";
    }

    // ERC20Interface functions implemented by OpenZeppelin's ERC20
    function balanceOf(address account) public view override(ERC20, ERC20Interface) returns (uint256) {
        return super.balanceOf(account);
    }

    function transfer(address recipient, uint256 amount) public override(ERC20, ERC20Interface) returns (bool) {
        return super.transfer(recipient, amount);
    }

    function approve(address spender, uint256 amount) public override(ERC20, ERC20Interface) returns (bool) {
        return super.approve(spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override(ERC20, ERC20Interface) returns (bool) {
        return super.transferFrom(sender, recipient, amount);
    }

    function allowance(address _owner, address spender) public view override(ERC20, ERC20Interface) returns (uint256) {
        return super.allowance(_owner, spender);
    }

    function totalSupply() public view override(ERC20, ERC20Interface) returns (uint256) {
        return super.totalSupply();
    }
}