// SPDX-License-Identifier:MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LW3Punks is ERC721Enumerable, Ownable {
    using Strings for uint256;

    string _baseTokenURI;

    uint256 public _price = 0.01 ether;

    bool public _paused;

    uint256 public _maxTokenIds = 10;

    uint256 public tokenIds;

    modifier onlyWhenNotPaused {
        require(!_paused, "The auction has been paused");
        _;
    }


    constructor (string memory baseURI) ERC721("LW3Punks", "LW3P") {
        _baseTokenURI = baseURI;
    }

    function _mint() public payable onlyWhenNotPaused {
        require (tokenIds < _maxTokenIds, "All nfts had been minted");
        require (msg.value >= _price, "You have to pay more...");

        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }
    /**
    * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
        * @dev tokenURI overides the Openzeppelin's ERC721 implementation for tokenURI function
        * This function returns the URI from where we can extract the metadata for a given tokenId
        */

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexisten token");

        string memory baseURI = _baseURI();

        // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
        // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given 
        // tokenId stored on IPFS
        // If baseURI is empty return an empty string
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    } 

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether.");
    }

    receive () external payable {}

    fallback () external payable {}

}