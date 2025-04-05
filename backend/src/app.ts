import express from "express";
import cors from "cors";
import stakingRouter from "./routes/staking";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/staking", stakingRouter);

export default app;
