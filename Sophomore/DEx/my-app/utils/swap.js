import { Contract } from "ethers";
import {
    EXCHANGE_CONTRACT_ABI,
    EXCHANGE_CONTRACT_ADDRESS,
    TOKEN_CONTRACT_ABI,
    TOKEN_CONTRACT_ADDRESS
} from "../constants"

export const getAmountOfTokensReceivedFromSwap = async (
    _swapAmountWei,
    provider,
    ethSelected,
    ethBalance,
    reserveCD
) => {
    const exchangeContract = new Contract (
        EXCHANGE_CONTRACT_ADDRESS,
        EXCHANGE_CONTRACT_ABI,
        // It would be nice to learn when to use provider and when signer
        provider
    );

    let amountOfTokens;
    
    if (ethSelected) {

        amountOfTokens = await exchangeContract.getAmountOfTokens(
        _swapAmountWei,
        ethBalance,
        reservedCD
    );
    } else {
        amountOfTokens = await exchangeContract.getAmountOfTokens(
            _swapAmountWei,
            reserveCD,
            ethBalance
        );
    }
    return amountOfTokens

}

export const swapTokens = async (
    
)