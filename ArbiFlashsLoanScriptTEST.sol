//SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

// import "./interfaces/Uniswap.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MySafeERC20.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyIERC20.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyUniswapV2Factory.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyUniswapV2Library.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyUniswapV2Pair.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyUniswapV2router01.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyUniswapV2router02.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MySafeMath.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyOtherERC20.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyOtherIERC20.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveFlashRecieverBase.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveFlashReciver.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveLendingPool.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyWithdrawable.sol"
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveLendingPoolAddProvider.sol"


contract MyArbiFlashLoanScriptTEST is AaveFlashRecieveBase {
    using MySafeERC20 for MyIERC20;

    interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

interface IERC3156MyArbiFlashLoanScriptTEST {
 
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}

interface IERC3156FlashLender {
   function flashLoan(
        IERC3156FlashBorrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

/*
*  FlashBorrowerExample is a simple smart contract that enables
*  to borrow and returns a flash loan.
*/
contract FlashloanBorrower is IERC3156FlashBorrower {
    uint public MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    address public admin;

    constructor() {
      admin = msg.sender;
    }

   
    function initiateFlashloan(
      address flashloanProviderAddress = "0xF1bE881Ee7034ebC0CD47E1af1bA94EC30DF3583"
      address token = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
      uint amount = 1000000000000000000000
      bytes calldata data = 0X0.0
    ) external {
      IERC3156FlashLender(flashloanProviderAddress).flashLoan(
        IERC3156FlashBorrower(address(this)),
        token,
        amount,
        data
      );
    }

    // @dev ERC-3156 Flash loan callback
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        
        // Set the allowance to payback the flash loan
        IERC20(token).approve(msg.sender, MAX_INT);
        
        
    swap ETH on Uniswap for USDT
    swap USDT on Uniswap for ETH
    payback flashloan
     

      // Return success to the lender, he will transfer get the funds back if allowance is set accordingly
        return keccak256('MyArbiFlashLoanScriptTEST.onFlashLoan');
    }

    function withdraw(address recipient, address token, uint amount) external {
      require(msg.sender == admin, 'only admin');
      IERC20(token).transfer(recipient, amount);
    }
}

  
  
   
   

 
     
      
