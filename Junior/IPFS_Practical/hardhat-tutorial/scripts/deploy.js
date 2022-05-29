const { ethers } = require("hardhat");
require("dotenv").config({path: ".env" });

async function main() {

    const metadataURL = "ipfs://Qmbygo38DWF1V8GttM1zy89KzyZTPU2FLUzQtiDvB7q6i5/";

    const LW3PunksContract = await ethers.getContractFactory("LW3Punks");

    const deployLW3 = await LW3PunksContract.deploy(metadataURL)

    await deployLW3.deployed();

    console.log("The address of the LW3 deployment is: ", deployLW3.address);
}


main ()
    .then(()=> process.exit(0))
    .catch((err) => {
    console.error(err);
    process.exit(1);})
