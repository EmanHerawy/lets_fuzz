// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BasicERC20} from "../src/BasicERC20.sol";


/// handler contract to manage invariant
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract Handler is CommonBase, StdCheats, StdUtils {
  address owner;
  BasicERC20 public basicERC20;
  constructor(BasicERC20 _basicERC20) {
    basicERC20 = _basicERC20;
    owner = msg.sender;

  }
function mint(address to, uint256 amount) public {
  //  vm.assume(to != address(0));
    vm.assume(basicERC20.totalSupply() >= basicERC20.cap());
    amount= bound(amount, basicERC20.totalSupply(), 100000 ether);
     vm.startPrank( owner);
    basicERC20.mint(to, amount);
}
function mintByUser(uint256 amount) public {
if(basicERC20.totalSupply() >= basicERC20.cap()){
    amount = bound(amount, 1, 1000);
        basicERC20.mintByUser(amount);

}
}

}

contract BasicERC20Test is Test {
    BasicERC20 public basicERC20;
    Handler public handler;
    function setUp() public {
        basicERC20 = new BasicERC20(100000 ether);
        handler = new Handler(basicERC20);
        targetContract(address(handler));
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = Handler.mint.selector;
        selectors[1] = Handler.mintByUser.selector;
        // selectors[2] = BasicERC20.sendToFallback.selector;

        // Handler.fail() not called
        targetSelector(
            FuzzSelector({addr: address(handler), selectors: selectors})
        );
        excludeSender(address(0))	;
    }
    // test mint function for minter role with fuzzing

   
    function invariant_Mint() public view{
   
        assertGe(basicERC20.totalSupply(), 0);
    }
    

}
