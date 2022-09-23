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
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MySafeMath.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyOtherERC20.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyOtherIERC20.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveFlashRecieverBase.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveFlashReciver.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveLendingPool.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/MyWithdrawable.sol";
import "https://github.com/Benjam6/Triangular-Flash/blob/main/AaveLendingPoolAddProvider.sol";

 
   

contract MyArbiFlashLoanScriptTEST is AaveFlashRecieveBase {
    using MySafeERC20 for MyIERC20;
    
    address public constant AaveLendingPoolAddressProviderAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant USDT_ADDRESS = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public constant UNISWAP_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    
    IUniswapFactory public uniswapFactory;
    IUniswapExchange public exchangeforLoanAsset;
    IUniswapExchange public exchangeforUSDT;
   

   constructor() public {
      // Override the addressesProvider in the base class to use Kovan for testing
      FlashLoanReceiverBase.addressesProvider = ILendingPoolAddressesProvider(
        AaveLendingPoolAddressProviderAddress
      );
   
   
  uniswapFactory = IUniswapFactory(UNISWAP_FACTORY);
  

      // get Exchange Address
      address addressForUSDTExchange = uniswapFactory.getExchange(USDT_ADDRESS);
  
   
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


contract FlashloanBorrower is IERC3156FlashBorrower {
    uint public MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    address public admin;

    constructor() {
      admin = msg.sender;
    }

   
    function initiateFlashloan(
      address flashloanProviderAddress = "0x6B175474E89094C44Da98b954EedeAC495271d0F"
      address token = "0x6B175474E89094C44Da98b954EedeAC495271d0F"
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
        
        function executeOperation(
        address _reserve,
        uint _amount,
        uint _fee,
        bytes calldata _params
    ) external {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        address RESERVE_ADDRESS = _reserve;
        uint256 deadline = now + 3000;

        // get Exchange Address for the reserve asset
        address addressForLoanAssetExchange = uniswapFactory.getExchange(RESERVE_ADDRESS);
    
        // Instantiate Exchange A
        exchangeforLoanAsset = IUniswapExchange(addressForLoanAssetExchange);
     

        IERC20 loan = IERC20(RESERVE_ADDRESS);
        IERC20 usdt = IERC20(USDT_ADDRESS);

        // Swap the reserve asset (e.g. DAI) for USDT
        require(loan.approve(address(exchangeBforLoanAsset), _amount), "Could not approve reserve asset sell");

        uint256 usdtPurchased = exchangeBforLoanAsset.tokenToTokenSwapInput(
            _amount,
            1,
            1,
            deadline,
            USDT_ADDRESS
        );

        require(usdt.approve(address(exchangeforUSDT), usdtPurchased), "Could not approve USDT asset sell");

        // Swap USDT back to the reserve asset (e.g. DAIs)
        uint256 reserveAssetPurchased = exchangeforUSDT.tokenToTokenSwapInput(
            usdtPurchased,
            1,
            1,
            deadline,
            RESERVE_ADDRESS
        );

        uint amount = _amount;

        uint totalDebt = amount.add(_fee);

        require(reserveAssetPurchased > totalDebt, "There is no profit! Reverting!");

        transferFundsBackToPoolInternal(RESERVE_ADDRESS, amount.add(_fee));
 
 
 
 uint256 profit = loan.balanceOf(address(this));
        require(loan.transfer(msg.sender, profit), "Could not transfer back the profit");
        
        
         }
}

 

  
  
   
   

 
     
      
