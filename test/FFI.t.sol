// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

contract FFITest is Test {

    function setUp() public {
     
    }
// forge test --match-path test/FFI.t.sol --ffi -vvvv
    function test_FFFI() public {
      string [] memory cmds = new string[](2);
        cmds[0] = "cat";
        cmds[1] = "test/Counter.t.sol";
     bytes memory res= vm.ffi(cmds);
     console.log(string(res));
    }


}
