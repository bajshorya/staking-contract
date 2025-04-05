export interface StakingInfo {
  stakedAmount: string;
  rewards: string;
  lastUpdated: Date;
}

export interface StakeRequest {
  amount: string;
  address: string;
}

export interface UnstakeRequest {
  amount: string;
  address: string;
}
