// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {NaryaTest} from "@narya-ai/NaryaTest.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "lib/forge-std/src/console.sol";

// https://github.com/SunWeb3Sec/DeFiHackLabs/blob/main/src/test/safeMoon_exp.sol

interface ISafemoon {
    function uniswapV2Pair() external returns (address);

    function bridgeBurnAddress() external returns (address);

    function approve(address spender, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);

    function mint(address user, uint256 amount) external;

    function burn(address from, uint256 amount) external;
}

contract OnChainSafemoonTest2 is NaryaTest {
    ISafemoon sfmoon = ISafemoon(0x42981d0bfbAf196529376EE702F2a9Eb9092fcB5);

    address agent;
    address user;
    uint initialBalance;

    function setUp() public {
        vm.createSelectFork("https://rpc.ankr.com/bsc", 26864889);

        agent = getAgent(0);
        user = makeAddr("User");

        // cannot use deal as non standard ERC20
        // instead we use the pair as a user since we know it wont be fuzzed
        // showcase public burning
        user = sfmoon.uniswapV2Pair();

        initialBalance = sfmoon.balanceOf(user);
        require(initialBalance != 0, "user has no funds");
        
        targetContract(address(sfmoon));
        targetAccount(user);
    }

    function invariantArbitraryFundsSafe() public {
        console.log(initialBalance);
        // lose more than 10%
        require(sfmoon.balanceOf(user) == initialBalance, "lost funds");
    }
}
