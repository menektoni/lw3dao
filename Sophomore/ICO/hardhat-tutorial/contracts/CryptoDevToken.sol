// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevsToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;

      // Each NFT would give the user 10 tokens
      // It needs to be represented as 10 * (10 ** 18) as ERC20 tokens are represented by the smallest denomination possible for the token
      // By default, ERC20 tokens have the smallest denomination of 10^(-18). This means, having a balance of (1)
      // is actually equal to (10 ^ -18) tokens.
      // Owning 1 full token is equivalent to owning (10^18) tokens when you account for the decimal places.
      // More information on this can be found in the Freshman Track Cryptocurrency tutorial.

    uint256 public constant tokensPerNFT = 10 *10**18;
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    ICryptoDevs CryptoDevsNFT;

    mapping (uint256 => bool) public tokenIdsClaimed;

    constructor (address _cryptoDevsContract) ERC20 ("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    function mint(uint256 amount) public payable {
        uint256 _requiredAmount = amount * tokenPrice;
        require(msg.value >= _requiredAmount, "You have to pay more");

        uint256 amountWithDecimals = amount * 10**18;
        // First time totalSupply() appearence. This means the sum of the tokens of all the holders.
        require(totalSupply() + amountWithDecimals< maxTotalSupply, "Run out of tokens");

        // Now we should send the tokens to the one claiming them. We are going to use the internal function _mint
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;

        uint256 balance = CryptoDevsNFT.balanceOf(sender);

        require(balance > 0, "You have to own one NFT at least to claim the tokens");
        
        uint256 amount = 0;
        for (uint256 i = 0; i < balance; i++) {

            // Here you should have to take a look more in depth to understand what's happening.
            uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
            if(!tokenIdsClaimed[tokenId]) {
                amount += 1;
                tokenIdsClaimed[tokenId] = true;

            }
        }

        require(amount > 0, "Tokens already claimed");

        _mint(msg.sender, amount*tokensPerNFT);
    }

    receive() external payable {}

    fallback() external payable {}

}
