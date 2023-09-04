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

contract OnChainSafemoonTest is NaryaTest {
    ISafemoon sfmoon = ISafemoon(0x42981d0bfbAf196529376EE702F2a9Eb9092fcB5);

    address agent;
    address user;

    function setUp() public {
        vm.createSelectFork("https://rpc.ankr.com/bsc", 26854757);

        agent = getAgent(0);
        user = makeAddr("User");

        require(sfmoon.balanceOf(user) == 0);
        
        targetContract(address(sfmoon));
        targetAccount(user);
    }

    function invariantDesignedProfitRangeBroken() public {
        require(sfmoon.balanceOf(user) == 0, "made profits");
    }
}
