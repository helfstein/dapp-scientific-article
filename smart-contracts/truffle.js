module.exports = {
  networks: {
      development: {
          host: "127.0.0.1",
          port: 8545, // Using ganache as development network
          network_id: "*",
          gas: 6721975,
          //gasPrice: 25000000000,
          //from: "0x6935cdf3fd206c2f43ee2f085c6e6ef48977ab01"
      } 
  },
  solc: {
      optimizer: {
          enabled: true,
          runs: 300
      }
  }
};