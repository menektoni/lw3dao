import { Contract } from "ethers";
import {
    EXCHANGE_CONTRACT_ABI,
    EXCHANGE_CONTRACT_ADDRESS,
    TOKEN_CONTRACT_ABI,
    TOKEN_CONTRACT_ADDRESS
} from "../constants";

/* 
getEtherBalance
*/
export const getEtherBalance = async (
    provider,
    address,
    contract = false
) =>  {
    try {
        // If the caller has set contract = true recieve de balance of the contract
        // If false return the balance of the user
        if (contract) {
            const balance = await provider.getBalance(EXCHANGE_CONTRACT_ADDRESS);
            return balance;
        } else {
            const balance = await provider.getBalance(address);
            return balance;
        } 
    } catch (err) {
        console.error(err);
        return 0
    }
}

// Get CD tokens balance  

export const getCDTokensBalance = async (provider, address) => { 
    try {const TokenContract = new Contract(
        TOKEN_CONTRACT_ADDRESS,
        TOKEN_CONTRACT_ABI,
        provider
    );
    const balanceOfCryptoDevTokens = await tokenContract.balanceOf(address);
    return balanceOfCryptoDevTokens;

    } catch (err) {
        console.error(err);
    }
};

// GetLPTokensReserve

export const getLPTokensReserve = async (provider, address) => {
    try {
        const exchangeContract = new Contract (
            EXCHANGE_CONTRACT_ADDRESS,
            EXCHANGE_CONTRACT_ABI,
            provider
        );
        const balanceOfLPTokens = exchangeContract.balanaceOf(address);
        return balanceOfLPTokens;
    } catch (err) {
        console.error(err);
    }
}


// GetReserveOfCDTokens
export const getReserveOfCDTokens = async (provider) => {
    try {
        const exchangeContract = new Contract(
            EXCHANGE_CONTRACT_ADDRESS,
            EXCHANGE_CONTRACT_ABI,
            provider
        );
        const reserve = await exchangeContract.getReserve();
        return reserve;
    } catch (err) {
        console.error(err);
    }
}


