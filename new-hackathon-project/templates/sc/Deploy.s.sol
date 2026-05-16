// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";

// import {YourContract} from "../src/YourContract.sol";

/**
 * Multi-chain deploy script.
 *
 * Usage:
 *   source .env
 *   forge script script/Deploy.s.sol \
 *     --rpc-url base_sepolia \
 *     --broadcast --verify -vvvv
 *
 * Available chains (see foundry.toml [rpc_endpoints]):
 *   base_sepolia | arbitrum_sepolia | optimism_sepolia | mantle_sepolia | monad_testnet
 */
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        console.log("Deployer:", deployer);
        console.log("Chain ID:", block.chainid);

        vm.startBroadcast(deployerPrivateKey);

        // YourContract c = new YourContract();
        // console.log("Deployed YourContract to:", address(c));
        //
        // _writeDeployment("YourContract", address(c));

        vm.stopBroadcast();
    }

    function _writeDeployment(string memory name, address addr) internal {
        string memory chain = vm.toString(block.chainid);
        string memory path = string.concat("deployments/", chain, ".json");
        string memory key = string.concat('"', name, '"');
        string memory value = string.concat('"', vm.toString(addr), '"');
        string memory line = string.concat("  ", key, ": ", value);
        console.log("Save:", path, line);
    }
}
