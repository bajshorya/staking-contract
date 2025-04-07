// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/BarcaCoin.sol";

contract BarcaCoinTest  is Test {
    BarcaCoinContract barcaCoin;

    function setUp () public{
        barcaCoin=new BarcaCoinContract(address(this));
    }
    function testInitialSupply() public view {
        assert(barcaCoin.totalSupply()==0);
    }
    function testFailMint() public {
        vm.startPrank(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        barcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);
    }
    function testMint() public {
        barcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);
        assert(barcaCoin.balanceOf(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88)==10);
    }
    function testChangeStakingContract() public{
        barcaCoin.updateStakingContract(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        vm.startPrank(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        barcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);  
        assert(barcaCoin.balanceOf(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88)==10);

    }
}
