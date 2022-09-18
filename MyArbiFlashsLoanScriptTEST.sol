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
import AAVE FLASH LOAN CONTRACTS


contract MyArbiFlashLoanScriptTEST {
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
      address flashloanProviderAddress = AAVE TESTNET VAULT
      address token = ETH address
      uint amount = 1000 PLUS DECIMALS
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

  
  
   
   

 
     
      
