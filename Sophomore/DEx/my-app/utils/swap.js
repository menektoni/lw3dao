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
    signer,
    swapAmountWei,
    tokenToBeReceivedAfterSwap,
    ethSelected
) => {
    const exchangeContract = new Contract (
        EXCHANGE_CONTRACT_ADDRESS,
        EXCHANGE_CONTRACT_ABI,
        signer
    );
    const tokenContract = new Contract (
        TOKEN_CONTRACT_ADDRESS,
        TOKEN_CONTRACT_ABI,
        signer
    );
    let tx;

  // If Eth is selected call the `ethToCryptoDevToken` function else
  // call the `cryptoDevTokenToEth` function from the contract
  // As you can see you need to pass the `swapAmount` as a value to the function because
  // it is the ether we are paying to the contract, instead of a value we are passing to the function
  if (ethSelected) {
      tx = await exchanfeContract.ethToCryptoDevToken(
          tokenToBeReceivedAfterSwap, {
              value: swapAmountWei,
          }
      );
  } else {
      tx = await tokenContract.approve(
          EXCHANGE_CONTRACT_ADDRESS,
          swapAmountWei.toString()
      );
      await tx.wait();

      tx = await exchangeContract.cryptoDevTokenToETH(
          swapAmountWei,
          tokenToBeReceivedAfterSwap
      );
  }
  await tx.wait();
}