import { Web3Provider } from "@ethersproject/providers"
import { useState, useRef, useEffect } from "react"
import Web3Modal from "web3modal"
import { useViewerConnection } from "@self.id/react"
import { EthereumAuthProvider } from "@self.id/web"

const web3ModalRef = useRef();

const getProvider = async () => {
  const provider = await web3ModalRef.current.connect();
  const wrappedProvider = new Web3Provider(provider);
  return wrappedProvider;
}

const [connection, connect, disconnect] = useViewerConnection();

useEffect(() => {
  if (connection.status !== "connected") {
    web3ModalRef.current = new Web3Modal({
      network: "rinkeby",
      providerOptions: {},
      disableINjectedProvider: false,
    });
  }
}, [connection.status]);

const connectToSelfId = async () => {
  const ethereumAuthProvider = await getEthereumAuthProvider();
  connect(ethereumAuthProvider);
};

const getEthereumAuthProvider = async () => {
  const wrappedProvider = await getProvider();
  const signer = wrappedProvider.getSigner();
  const address = await signer.getAddress();
  return new EthereumAuthProvider(wrappedProvider.provider, address);
};

