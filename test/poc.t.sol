// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {NaryaTest} from "@narya-ai/NaryaTest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "lib/forge-std/src/console.sol";
import {Safemoon} from "src/Safemoon.sol";

// https://github.com/SunWeb3Sec/DeFiHackLabs/blob/main/src/test/safeMoon_exp.sol

contract safemoonTest is NaryaTest {
    Safemoon sfmoon;

    address agent;

    function setUp() public {
        sfmoon = new Safemoon();
        sfmoon.initialize();

        agent = getAgent(0);

        require(sfmoon.balanceOf(agent) == 0);
        
        targetAccount(agent);
    }

    function invariantDesignedProfitRangeBroken() public {
        require(sfmoon.balanceOf(agent) == 0, "made profits");
    }
}
