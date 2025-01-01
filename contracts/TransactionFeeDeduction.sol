// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @title TransactionFeeDeduction
 * @dev Implements a mechanism to deduct 5% of the transaction amount and deposit it into a specified fee wallet.
 * The remaining 95% is sent to the recipient.
 */
contract TransactionFeeDeduction {
    /// @notice Address where the deducted fees will be deposited.
    address public feeWallet;

    /// @notice Fee percentage deducted from each transaction (5%).
    uint256 public constant FEE_PERCENTAGE = 5;

    /// @notice Denominator for calculating the percentage (100%).
    uint256 public constant PERCENTAGE_DENOMINATOR = 100;

    /**
     * @dev Initializes the contract with the fee wallet address.
     * @param _feeWallet The address to receive the deducted fees.
     */
    constructor(address _feeWallet) {
        require(_feeWallet != address(0), "Fee wallet address cannot be zero.");
        feeWallet = _feeWallet;
    }

    /**
     * @notice Transfers an amount after deducting a 5% fee.
     * @dev Calculates the fee and transfers the remaining amount to the recipient.
     * The fee is transferred to the fee wallet.
     * @param recipient The address to receive the remaining funds.
     * @param amount The total amount to be transferred.
     */
    function transferWithFee(
        address payable recipient,
        uint256 amount
    ) external payable {
        require(recipient != address(0), "Recipient address cannot be zero.");
        require(amount > 0, "Amount must be greater than zero.");
        require(
            msg.value == amount,
            "Sent value must match the specified amount."
        );

        // Calculate the fee amount.
        uint256 fee = (amount * FEE_PERCENTAGE) / PERCENTAGE_DENOMINATOR;

        // Calculate the remaining amount after deducting the fee.
        uint256 remainingAmount = amount - fee;

        // Transfer the fee to the fee wallet.
        (bool feeSent, ) = feeWallet.call{value: fee}("");
        require(feeSent, "Fee transfer failed.");

        // Transfer the remaining amount to the recipient.
        (bool remainingSent, ) = recipient.call{value: remainingAmount}("");
        require(remainingSent, "Transfer to recipient failed.");
    }

    /**
     * @notice Updates the fee wallet address.
     * @dev Only callable by the current fee wallet address.
     * @param _newFeeWallet The new fee wallet address.
     */
    function updateFeeWallet(address _newFeeWallet) external {
        require(
            msg.sender == feeWallet,
            "Only the fee wallet can update the fee address."
        );
        require(
            _newFeeWallet != address(0),
            "New fee wallet address cannot be zero."
        );
        feeWallet = _newFeeWallet;
    }
}
