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

            // Concepts here aren't clear. Rewatch.
            uint ethReserve = ethBalance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve) / (ethReserve);

            require (_amount >= cryptoDevTokenAmount, "You're not assuring constan liquidity.");

            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);

            liquidity = (totalSupply() * msg.value)/(ethReserve);

            _mint(msg.sender, liquidity);
        }
        return liquidity;
    }
}