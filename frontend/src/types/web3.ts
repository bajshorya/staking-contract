import { BrowserProvider, Signer } from "ethers";

export interface Web3ContextType {
  provider: BrowserProvider | null;
  signer: Signer | null;
  address: string;
  isConnected: boolean;
  connectWallet: () => Promise<void>;
  disconnect: () => void;
}
