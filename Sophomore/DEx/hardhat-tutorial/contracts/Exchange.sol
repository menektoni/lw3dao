// SPDX-License-Identifier: MIT

pragma solidity^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20 {

    address public cryptoDevTokenAddress;


    constructor(address _CryptoDevToken) ERC20("CryptoDev LP Token", "CDLP") {
        require (_CryptoDevToken != address(0), "Null address");
        cryptoDevTokenAddress = _CryptoDevToken;
    }

    function getReserve() public view returns (uint) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    function addLiquidity(uint _amount) public payable returns (uint) {
        uint liquidity;
        uint ethBalance = address(this).balance;
        uint cryptoDevTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        if (cryptoDevTokenReserve == 0) {
            // Sending the cryptoDevToken to the contract
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
            // liquidity is in ethereum because it's the first time user is
            // adding ETH to the contract.
            liquidity = ethBalance;
            
            _mint(msg.sender, liquidity);

        } else {

            uint ethReserve = ethBalance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve) / (ethReserve);

            require (_amount >= cryptoDevTokenAmount, "You're not assuring constan liquidity.");

            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);

            // Check where liquidity comes from
            liquidity = (totalSupply() * msg.value)/(ethReserve);

            _mint(msg.sender, liquidity);
        }
        return liquidity;
    }

    function remove_liquidity (uint _amount) public returns (uint , uint) {
        // The mission of this function is to be able for the user to remove liquidity
        require(_amount > 0, "You don't have LP");
        uint ethReserve = address(this).balance;
        uint _totalSupply = totalSupply();

        uint ethAmount = (ethReserve * _amount)/(_totalSupply);

        uint cryptoDevTokenAmount = (getReserve() * _amount)/(_totalSupply);

        // Burn is an openzeppelin built-in function.
        _burn(msg.sender, _amount);
        // Transfer `ethAmount` of Eth from user's wallet to the contract
        payable(msg.sender).transfer(ethAmount);
        // Transfer `cryptoDevTokenAmount` of Crypto Dev tokens from the user's wallet to the contract
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);

        return (ethAmount, cryptoDevTokenAmount);
    }

    // Let's calculate the amount of tokens
    function getAmountOfTokens(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve
    ) public pure returns (uint256) {
        require (inputReserve > 0 && outputReserve > 0, "Out of reserves");
        // Fee charging
        uint256 inputAmountWithFee = inputAmount * 99;

        uint numerator = inputAmountWithFee * outputReserve;
        uint denominator = (inputReserve * 100) + inputAmountWithFee;

        return numerator/denominator;
    }
    // Let's make the swap ether for CryptoDevsToken
    function ethToCryptoDevToken(uint _minTokens) public payable {
        uint256 tokenReserve = getReserve();

        uint256 tokensBought = getAmountOfTokens(
            msg.value, 
            address(this).balance - msg.value, 
            // Why value of outputReserve is tokenReserve. It's because what we are swapping
            tokenReserve); 

        require (tokensBought >= _minTokens, "Insufficient output amount");

        ERC20(cryptoDevTokenAddress).transfer(msg.sender, tokensBought);
    } 

    // Let's make the swap CryptoDevToken for ether
    function cryptoDevTokenToEth (uint256 _tokensSold, uint256 _minEth) public {
        uint TokenReserve = getReserve();
        uint256 ethBought =getAmountOfTokens(
            _tokensSold, 
            TokenReserve, 
            address(this).balance);

        require(ethBought >= _minEth, "Insufficient output amount");

        // Sending _tokensSold to the contract
        ERC20(cryptoDevTokenAddress).transferFrom(msg.sender, address(this), _tokensSold);
        // Sending ETH to the msg.sender
        payable(msg.sender).transfer(ethBought);
    }
}