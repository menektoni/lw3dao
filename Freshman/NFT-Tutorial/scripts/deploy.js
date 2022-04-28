// Importing ethers hardhat package
const { ethers } = require("hardhat");

async function main() {
     /*
A ContractFactory in ethers.js is an abstraction used to deploy new smart contracts,
so nftContract here is a factory for instances of our GameItem contract.
*/

const nftContract = await ethers.getContractFactory("GameItem");

// Deploying the contract
const deployedNFTContract = await nftContract.deploy();

// Printing the address of the deployed contract
console.log("The Contract Address is:", deployedNFTContract.address);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });