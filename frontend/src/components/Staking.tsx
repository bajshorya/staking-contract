import React, { useState, useEffect } from "react";
import { useWeb3 } from "../context/Web3Context";
import axios from "axios";

interface StakingInfo {
  stakedAmount: string;
  rewards: string;
  lastUpdated: string;
}

const Staking: React.FC = () => {
  const { provider, signer, address, isConnected, connectWallet } = useWeb3();
  const [stakedAmount, setStakedAmount] = useState<string>("0");
  const [rewards, setRewards] = useState<string>("0");
  const [ethAmount, setEthAmount] = useState<string>("");
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const loadData = async () => {
    if (!isConnected) return;
    setIsLoading(true);
    try {
      const response = await axios.get<StakingInfo>(
        `http://localhost:3001/api/staking/info/${address}`
      );
      setStakedAmount(response.data.stakedAmount);
      setRewards(response.data.rewards);
    } catch (error) {
      console.error("Error loading staking data:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, [isConnected, address]);

  const handleStake = async () => {
    if (!ethAmount || !address) return;
    setIsLoading(true);
    try {
      await axios.post("http://localhost:3001/api/staking/stake", {
        amount: ethAmount,
        address,
      });
      await loadData();
    } catch (error) {
      console.error("Error staking:", error);
    } finally {
      setIsLoading(false);
    }
  };

  if (!isConnected) {
    return <button onClick={connectWallet}>Connect Wallet</button>;
  }

  return (
    <div className="staking-container">
      <h2>Staking Dashboard</h2>
      <p>Connected: {address}</p>

      {isLoading ? (
        <p>Loading...</p>
      ) : (
        <>
          <p>Staked: {stakedAmount} ETH</p>
          <p>Rewards: {rewards} ORC</p>
        </>
      )}

      <div className="staking-input">
        <input
          type="number"
          value={ethAmount}
          onChange={(e) => setEthAmount(e.target.value)}
          placeholder="ETH amount"
          disabled={isLoading}
        />
        <button onClick={handleStake} disabled={isLoading}>
          {isLoading ? "Processing..." : "Stake"}
        </button>
      </div>

      <button
        disabled={isLoading}
        onClick={() => {
          /* unstake function */
        }}
      >
        Unstake
      </button>
      <button
        disabled={isLoading}
        onClick={() => {
          /* claim function */
        }}
      >
        Claim Rewards
      </button>
    </div>
  );
};

export default Staking;
