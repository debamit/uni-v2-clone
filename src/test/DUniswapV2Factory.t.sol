// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

import "ds-test/test.sol";
import "../DuniswapV2Factory.sol";
import "../DuniswapV2Pair.sol";
import "solmate/test/utils/mocks/MockERC20.sol";

interface Vm {
    function expectRevert(bytes calldata) external;
}

contract ZuniswapV2FactoryTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);

    DuniswapV2Factory factory;

    MockERC20 token0;
    MockERC20 token1;
    MockERC20 token2;
    MockERC20 token3;

    function setUp() public {
        factory = new DuniswapV2Factory();

        token0 = new MockERC20("Token A", "TKNA", 18);
        token1 = new MockERC20("Token B", "TKNB", 18);
        token2 = new MockERC20("Token C", "TKNC", 18);
        token3 = new MockERC20("Token D", "TKND", 18);
    }

    function encodeError(string memory error)
        internal
        pure
        returns (bytes memory encoded)
    {
        encoded = abi.encodeWithSignature(error);
    }

    function testCreatePair() public {
        address pairAddress = factory.createPair(
            address(token0),
            address(token1)
        );

        DuniswapV2Pair pair = DuniswapV2Pair(pairAddress);

        assertEq(pair.token0(), address(token0));
        assertEq(pair.token1(), address(token1));
    }

    function testCreatePairZeroAddress() public {
        vm.expectRevert(encodeError("ZeroAddress()"));
        factory.createPair(address(0), address(token0));

        vm.expectRevert(encodeError("ZeroAddress()"));
        factory.createPair(address(token1), address(0));
    }

    function testCreatePairPairExists() public {
        factory.createPair(address(token1), address(token0));

        vm.expectRevert(encodeError("PairExists()"));
        factory.createPair(address(token1), address(token0));
    }

    function testCreatePairIdenticalTokens() public {
        vm.expectRevert(encodeError("IdenticalAddresses()"));
        factory.createPair(address(token0), address(token0));
    }
}
