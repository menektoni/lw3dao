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
        } catch (err) {
            console.error(err);
            return 0
        }
    }
}