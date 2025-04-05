import React from "react";
import { Web3Provider } from "./context/Web3Context";
import Staking from "./components/Staking";

const App: React.FC = () => {
  return (
    <Web3Provider>
      <div className="App">
        <header>
          <h1>Orca Staking Platform</h1>
        </header>
        <main>
          <Staking />
        </main>
      </div>
    </Web3Provider>
  );
};

export default App;
