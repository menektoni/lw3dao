//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./IWhitelist.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CryptoDevs is ERC721Enumerable, Ownable {

    string _baseTokenURI;

    uint256 public _price = 0.01 ether;

    bool public _paused;

    uint256 public maxTokenIds = 20;

    uint256 public tokenIds;

    // Whitelist contract instance.
    IWhitelist whitelist;

    bool public presaleStarted;
    // This will contain a timestamp limit for the presale.
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused.");
        _;
    }

    constructor (string memory baseURI, address whitelistContract) ERC721("CryptoDevs", "CD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Realy nice by solidity to have cool timestamps integrated (days, minutes, seconds or even years)
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "The presale has ended");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not elegible for the presale");
        require(tokenIds < maxTokenIds, "Sold out");
        require(msg.value >= _price, "Ether sent is not enough");

        tokenIds += 1;

        _safeMint(msg.sender, tokenIds);
    }


    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet.");
        require(msg.value >= _price, "If you want the NFT give us more ETH");
        require(tokenIds < maxTokenIds, "Sold out");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused (bool val) onlyOwner public {
        _paused = val;
    }

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent, ) = _owner.call{ value: amount }("");
        require(sent, "Failed to send ether");
    }

    receive() external payable {}

    fallback() external payable {}

}