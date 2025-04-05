import { ethers } from "ethers";
import dotenv from "dotenv";

dotenv.config();

// For Ethers.js v6
const provider = new ethers.AlchemyProvider(
  "sepolia",
  process.env.ALCHEMY_API_KEY
);

const wallet = new ethers.Wallet(process.env.PRIVATE_KEY!, provider);

export { provider, wallet };
