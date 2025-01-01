// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract PULSR is ERC20 {
    constructor() ERC20("puslr", "PULSR") {
        // Mint 1 billion tokens to the contract deployer (owner)
        _mint(msg.sender, 1000000000000 * 10**18); // 1 billion tokens with 18 decimal places
    
    }

    function mint(address reciever , uint amount) external{
        _mint(reciever, amount);
    }
}