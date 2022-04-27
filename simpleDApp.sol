// SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

contract MoodDiary {
    string mood;

    // function that writes
    function setMood (string memory _mood) public {
        mood = _mood;
    }

    // function that read the mood
    function getMood () public view returns (string memory) {
        return mood;
    }
}