// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SimplePaymaster
 * @dev Simplified Paymaster to sponsor gas fees using ERC-20 tokens with a default or supplied conversion rate.
 */
contract SimplePaymaster {
    /// @notice Mapping to store token-to-ETH conversion rates (1 ETH = rate tokens)
    mapping(address => uint256) public tokenRates;

    /// @notice Tracks ETH balance of the Paymaster
    uint256 public ethBalance;

    event TokenRateUpdated(address indexed token, uint256 rate);
    event GasSponsored(
        address indexed user,
        address indexed token,
        uint256 tokenAmount
    );
    event FundsWithdrawn(address indexed to, uint256 amount);

    constructor() {}

    /**
     * @notice Sets or updates the conversion rate for an ERC-20 token.
     * @param token The address of the ERC-20 token.
     * @param rate The conversion rate (tokens per ETH) in 1e18 precision.
     */
    function setTokenRate(address token, uint256 rate) external {
        require(rate > 0, "Rate must be greater than zero");
        tokenRates[token] = rate;
        emit TokenRateUpdated(token, rate);
    }

    /**
     * @notice Sponsors gas fees for a user by deducting ERC-20 tokens based on the conversion rate.
     * @param token The address of the ERC-20 token used for payment.
     * @param user The address of the user making the transaction.
     * @param maxCost The maximum gas cost in ETH for the transaction.
     */
    function sponsorGas(address token, address user, uint256 maxCost) external {
        uint256 rate = tokenRates[token];
        require(rate > 0, "Token not supported");

        // Calculate required tokens based on maxCost (ETH) and the rate
        uint256 requiredTokens = (maxCost * rate) / 1e18;

        // Transfer the tokens from the user to the Paymaster
        IERC20 erc20Token = IERC20(token);
        require(
            erc20Token.transferFrom(user, address(this), requiredTokens),
            "Token transfer failed"
        );

        emit GasSponsored(user, token, requiredTokens);
    }

    /**
     * @notice Allows the owner to withdraw ERC-20 tokens from the Paymaster.
     * @param token The address of the ERC-20 token to withdraw.
     * @param to The address to send the tokens to.
     * @param amount The amount of tokens to withdraw.
     */
    function withdrawTokens(
        address token,
        address to,
        uint256 amount
    ) external {
        IERC20(token).transfer(to, amount);
    }

    /**
     * @notice Allows the owner to withdraw ETH from the Paymaster.
     * @param to The address to send the ETH to.
     * @param amount The amount of ETH to withdraw.
     */
    function withdrawETH(address to, uint256 amount) external {
        require(ethBalance >= amount, "Insufficient ETH balance");
        ethBalance -= amount;
        (bool success, ) = to.call{value: amount}("");
        require(success, "ETH withdrawal failed");

        emit FundsWithdrawn(to, amount);
    }

    // Allow the Paymaster to receive ETH
    receive() external payable {
        ethBalance += msg.value;
    }
}
