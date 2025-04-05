import { Router, Request, Response } from "express";
import { StakingInfo, StakeRequest } from "../types/staking";
import { wallet } from "../config/web3";
import { ethers } from "ethers";

const router = Router();

// Load contract ABI and address
const stakingContract = new ethers.Contract(
  process.env.CONTRACT_ADDRESS!,
  require("../../artifacts/contracts/StakingContract.sol/StakingContract.json").abi,
  wallet
);

router.post("/stake", async (req: Request, res: Response) => {
  try {
    const { amount, address } = req.body as StakeRequest;
    const tx = await stakingContract.stake({
      value: ethers.parseEther(amount), // Changed from utils.parseEther to ethers.parseEther
    });
    await tx.wait();
    res.json({ success: true, txHash: tx.hash });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

router.get("/info/:address", async (req: Request, res: Response) => {
  try {
    const address = req.params.address;
    const staked = await stakingContract.balances(address);
    const rewards = await stakingContract.getReward(address);

    const info: StakingInfo = {
      stakedAmount: ethers.formatEther(staked), // Changed from utils.formatEther to ethers.formatEther
      rewards: ethers.formatEther(rewards), // Changed from utils.formatEther to ethers.formatEther
      lastUpdated: new Date(),
    };

    res.json(info);
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
});

export default router;
