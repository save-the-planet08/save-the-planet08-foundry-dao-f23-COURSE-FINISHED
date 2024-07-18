// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {MyGovernor} from "../src/MyGovenor.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {Box} from "../src/Box.sol";
import {GovToken} from "../src/GovToken.sol";

contract MyGovernorTest is Test {
    MyGovernor govenor;
    Box box;
    TimeLock timelock; 
    GovToken govToken;


    address public USER = makeAddr("user");
    uint256 public constant INITIAL_SUPPLY = 100 ether;

    address [] proposers;
    address [] executors;
    uint256 [] values;
    bytes [] calldatas;
    address [] targets;


    uint256 public constant MIN_DELAY = 3600;
    uint256 public constant VOTING_DELAY = 1;
    uint256 public constant VOTING_PERIOD = 50400;

    
    function setUp() public {
        govToken = new GovToken();
        govToken.mint(USER, INITIAL_SUPPLY);
        vm.startPrank(USER);
        govToken.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executors);
        govenor = new MyGovernor(govToken, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.DEFAULT_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(govenor));
        timelock.grantRole(executorRole, address(0));
        //stimelock.revokeRole(adminRole, USER);
        vm.stopPrank();
        box = new Box();
        box.transferOwnership(address(timelock));
        //box.transferOwnership(address(timelock));
        //controlled = new Controlled(address(timelock));
    }

    function testCanUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);

    }

    function testGovernanceUpdatesBox() public {
        uint256 valueToStore = 124;
        string memory description = "Update Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        values.push(0);
        calldatas.push(encodedFunctionCall);
        targets.push(address(box));
        uint256 proposalId = govenor.propose(targets, values, calldatas, description);  
        console.log("Proposal State: ", uint256(govenor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY+ 1);
        vm.roll(block.number + VOTING_DELAY+ 1);
        console.log("Proposal State: ", uint256(govenor.state(proposalId)));
        string memory reason = "Number is cool";
        uint8 voteWay = 1;
        vm.prank(USER);
        govenor.castVoteWithReason(proposalId, voteWay, reason);
        
        vm.warp(block.timestamp + VOTING_PERIOD+ 1);
        vm.roll(block.number + VOTING_PERIOD+ 1);

        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        govenor.queue(targets,values, calldatas, descriptionHash);

         vm.warp(block.timestamp + MIN_DELAY+ 1);
        vm.roll(block.number + MIN_DELAY+ 1);

        govenor.execute(targets, values, calldatas, descriptionHash);
        assertEq(box.getNumber(), valueToStore);
    }
}