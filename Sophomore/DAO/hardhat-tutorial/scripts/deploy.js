const { ethers } = require("hardhat");
const { CRYPTODEVS_NFT_CONTRACT } = require("../constants");


async function main() {

    // FakeNftMarketplaceDeployment
    const FakeNFTMarketplace = await ethers.getContractFactory("FakeNFTMarketplace");

    const fakeNFTMarketplace = await FakeNFTMarketplace.deploy();
    await fakeNFTMarketplace.deployed();

    console.log("FakeNftMarketplace address is: ", fakeNFTMarketplace.address);


    // CryptoDevsDaoDeployment
    const CryptoDevsDao = await ethers.getContractFactory("CryptoDevsDAO");

    const cryptoDevsDao = await CryptoDevsDao.deploy(
        CRYPTODEVS_NFT_CONTRACT,
        fakeNFTMarketplace.address,

        {
            //This assumes your account has at least 1 ethereum
            value: ethers.utils.parseEther("1")
        }
    );
    await cryptoDevsDao.deployed();

    console.log("CryptoDevs DAO address is: ", cryptoDevsDao.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    })