// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "../src/OrcaCoin.sol";

contract OrcaCoinTest  is Test {
    OrcaCoinContract orcaCoin;

    function setUp () public{
        orcaCoin=new OrcaCoinContract(address(this));
    }
    function testInitialSupply() public view {
        assert(orcaCoin.totalSupply()==0);
    }
    function testFailMint() public {
        vm.startPrank(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        orcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);
    }
    function testMint() public {
        orcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);
        assert(orcaCoin.balanceOf(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88)==10);
    }
    function testChangeStakingContract() public{
        orcaCoin.updateStakingContract(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        vm.startPrank(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88);
        orcaCoin.mint(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88, 10);  
        assert(orcaCoin.balanceOf(0x09BE7A03977DA2D840C5fEB7C30048a34D3A8c88)==10);

    }
}
