// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "ds-test/test.sol";
import "../DuniswapV2Pair.sol";
import "forge-std/Vm.sol";
import "solmate/test/utils/mocks/MockERC20.sol";

contract DuniswapV2PairTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);
    DuniswapV2Pair pair;
    MockERC20 token0;
    MockERC20 token1;

    function setUp() public {
        token0 = new MockERC20("TestToken0", "TTT", 18);
        vm.label(address(token0), "TestToken0");

        token1 = new MockERC20("TestToken1", "WWW", 18);
        vm.label(address(token1), "TestToken1");
        pair = new DuniswapV2Pair(address(token0), address(token1));

        token0.mint(address(this), 10 ether);
        token1.mint(address(this), 10 ether);
    }

    function assertReserves(uint112 expectedReserve0, uint112 expectedReserve1)
        internal
    {
        (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();
        assertEq(reserve0, expectedReserve0, "unexpected reserve0");
        assertEq(reserve1, expectedReserve1, "unexpected reserve1");
    }

    function testMintBootstrap() public {
        token0.approve(address(pair), 1 ether);
        token0.transfer(address(pair), 1 ether);
        token1.approve(address(pair), 1 ether);
        token1.transfer(address(pair), 1 ether);

        pair.mint();

        assertEq(pair.balanceOf(address(this)), 1 ether - 1000);
        assertReserves(1 ether, 1 ether);
        assertEq(pair.totalSupply(), 1 ether);
    }
}

contract TestUser {
    function provideLiquidity(
        address pairAddress_,
        address token0Address_,
        address token1Address_,
        uint256 amount0_,
        uint256 amount1_
    ) public {
        ERC20(token0Address_).transfer(pairAddress_, amount0_);
        ERC20(token1Address_).transfer(pairAddress_, amount1_);

        DuniswapV2Pair(pairAddress_).mint();
    }

    // function withdrawLiquidity(address pairAddress_) public {
    //     DuniswapV2Pair(pairAddress_).burn();
    // }
}
