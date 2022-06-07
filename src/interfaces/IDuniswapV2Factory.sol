// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.10;

interface IDuniswapV2Factory {
    function pairs(address, address) external pure returns (address);

    function createPair(address, address) external returns (address);
}
