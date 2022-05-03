// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FakeNFTMarketplace {
    // Token id and it's owner.
    mapping(uint256 => address) public tokens;

    uint nftPrice = 0.1 ether;

    function purchase(uint256 _tokenID) external payable {
        require(msg.value >= nftPrice, "Not enough money broo");
        tokens[_tokenID] = msg.sender; 
    }

    function getPrice() external view returns (uint256) {
        return nftPrice;
    }

    function available (uint256 _tokenId) external view returns (bool) {
        // Default ethereum address is address(0) and it means "0x0000...0"
        if (tokens[_tokenId] == address(0)) {
            return true;
        } else {
            return false;
        }
    }
}