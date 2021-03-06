// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract RandomWinnerGame is VRFConsumerBase, Ownable {

    //Chainlink variables
    uint256 public fee;

    bytes32 public keyHash;

    address[] public players;

    uint8 maxPlayers;

    bool public gameStarted;

    uint256 entryFee;

    uint256 public gameId;

    // emmit events
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 gameFee);
    event PlayerJoined(uint256 gameId, address player);
    event GameEnded(uint256 gameId, address winner, bytes32 requestId);

   /**
   * constructor inherits a VRFConsumerBase and initiates the values for keyHash, fee and gameStarted
   * @param vrfCoordinator address of VRFCoordinator contract
   * @param linkToken address of LINK token contract
   * @param vrfFee the amount of LINK to send with the request
   * @param vrfKeyHash ID of public key against which randomness is generated
   */

   constructor(address vrfCoordinator, address linkToken, uint256 vrfFee, bytes32 vrfKeyHash)
   VRFConsumerBase(vrfCoordinator, linkToken) {
       keyHash = vrfKeyHash;
       fee = vrfFee;
       gameStarted = false;
   }


   function startGame (uint8 _maxPlayers, uint256 _entryFee) public onlyOwner {
       require(!gameStarted, "Game Already Started");

       delete players; 
       maxPlayers = _maxPlayers;
       entryFee = _entryFee;
       gameStarted = true;

       gameId += 1;

       emit GameStarted(gameId, maxPlayers, entryFee);
   }

   function joinGame () public payable {
       require(gameStarted, "Game hasn't been started.");

       require(msg.value == entryFee, "Value isn't equal to the entry fee");

       require(players.length > maxPlayers, "Game is full");

       players.push(msg.sender);
       emit PlayerJoined(gameId, msg.sender);

       if (players.length == maxPlayers) {
           getRandomWinner();
       }
   }

   function fulfillRandomness(bytes32 requestId, uint256 randomness) internal virtual override {
       uint256 winnerIndex = randomness % players.length;

       address winner = players[winnerIndex];

       (bool sent,) = winner.call{value: address(this).balance}("");
       require(sent, "Transaction Failed");

       emit GameEnded(gameId, winner, requestId);

       gameStarted = false;
   }

   function getRandomWinner() private returns (bytes32 requestId) {
       require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");

       return requestRandomness(keyHash, fee);
   }

    receive() external payable {}

    fallback() external payable {}
}