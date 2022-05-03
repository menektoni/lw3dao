// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IFakeNFTMarketplace {
    function getPrice() external view returns(uint256);

    function available(uint256 _tokenId) external view returns(bool);

    function purchase(uint256 _tokenId) external payable;
}

interface ICryptoDevsNFT {
    /*
    Because CryptoDevsNFT is a ERC721 contract all the built-in functions 
    of ERC721 exist in the contract to. Both of the functions used below are 
    built-in functions
    */
    function balanceOf(address owner) external view returns(uint256);

    function tokenOfOwnerByIndex (address owner, uint256 _tokenId)
        external
        view
        returns(uint256);
}

contract CryptoDevsDAO is Ownable {

    struct Proposal {
        uint256 nftTokenId;
        uint256 deadLine;
        uint256 yayVotes;
        uint256 nayVotes;
        bool executed;
        mapping (uint256 => bool) voters;
    }

    mapping (uint256 => Proposal) public proposals;

    uint256 public numProposals;

    // Now we are going to create the instances.
    ICryptoDevsNFT cryptoDevsNFT;
    IFakeNFTMarketplace nftMarketplace;

    // Ownable means that the contract deployer is considered the contract owner
    constructor (address _cryptoDevsNFT, address _nftMarketplace) payable {
        nftMarketplace = IFakeNFTMarketplace(_nftMarketplace);
        cryptoDevsNFT = ICryptoDevsNFT(_cryptoDevsNFT);
    }
    modifier nftHolderOnly() {
        require(cryptoDevsNFT.balanceOf(msg.sender) >= 1, "You are not a holder");
        _;
    }

    function createProposal (uint256 _tokenId) 
        external
        nftHolderOnly
        returns (uint256) {
            require(nftMarketplace.available(_tokenId) == true, "NFT not available");
            Proposal storage proposal = proposals[numProposals];
            proposal.nftTokenId = _tokenId;
            // Arbitrary timestamp value
            proposal.deadLine = block.timestamp + 5 minutes;

            numProposals++;

            return (numProposals - 1);
        }

    modifier activeProposal (uint256 proposalIndex) {
        require(block.timestamp < proposals[proposalIndex].deadLine, "Deadline exceeded");
        _;
    }

    enum Vote {
        YAY, // YAY = 1
        NAY // NAY = 0
    }

    function voteOnProposal (uint256 proposalIndex, Vote vote)
        external
        nftHolderOnly
        activeProposal(proposalIndex)
        {
            // I don't get why we should have to do this again.
            Proposal storage proposal = proposals[proposalIndex];

            uint256 voterNFTBalance = cryptoDevsNFT.balanceOf(msg.sender);
            uint256 numVotes;

            /*
            This is interesting. ¿Why are we doing this and not
            multiplying the voterNFTBalance * vote? Because if done
            this way an NFT transacted meanwhile the voting could
            vote twice.
            */
            for (uint256 i=0; i < voterNFTBalance; i++) {
                if (proposal.voters[i] == false) {
                    proposal.voters[i] = true;
                    numVotes++;
                } 
            }
            require(numVotes>0, "Already voted");

            if(vote == Vote.YAY) {
                proposal.yayVotes += numVotes;
            } else {
                proposal.nayVotes += numVotes;
            }
        }

    modifier inactiveProposalOnly(uint256 proposalIndex) {
        require(proposals[proposalIndex].deadLine < block.timestamp,
         "Still Voting");
        require(proposals[proposalIndex].executed == false,
         "The proposal has already been executed");
        _;
    }

    function executeProposal(uint256 proposalIndex)
        external
        nftHolderOnly
        inactiveProposalOnly(proposalIndex)
    {
        Proposal storage proposal = proposals[proposalIndex];

        if (proposal.yayVotes > proposal.nayVotes) {
            uint256 nftPrice = nftMarketplace.getPrice();
            require(address(this).balance > nftPrice, "Not enough funds");
            nftMarketplace.purchase{value: nftPrice}(proposal.nftTokenId);
        }
        proposal.executed = true;
    }

    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    // You should deep dive why are we always adding this two functions.
    receive() external payable {}

    fallback() external payable {}

}