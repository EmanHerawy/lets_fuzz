// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BasicERC20} from "../src/BasicERC20.sol";

contract BasicERC20Test is Test {
    BasicERC20 public basicERC20;

    function setUp() public {
        basicERC20 = new BasicERC20(100000 ether);
    }
    // test mint function for minter role with fuzzing

    function testFuzz_Mint(address to, uint256 amount) public {
        vm.assume(to != address(0));
        //  vm.assume(amount <= 100000 ether);
        //using bound
        amount = bound(amount, 1, 100000 ether);
        basicERC20.mint(to, amount);
        assertEq(basicERC20.balanceOf(to), amount);
    }

    function testFuzz_mintByUser(uint256 amount) public {
        address user = address(0x123);
        vm.startPrank(user);
        vm.assume(amount <= 1000);
        basicERC20.mintByUser(amount);
        assertEq(basicERC20.balanceOf(user), amount);
    }
}
