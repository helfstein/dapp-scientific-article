module.exports = {
  networks: {
      development: {
          host: "127.0.0.1",
          port: 7545, // Using ganache as development network
          network_id: "*",
          gas: 6721975,
          //gasPrice: 25000000000,
          //from: "0x77D5096dd1253E77F884768148a307aeC92C07FD"
      }
  },
  solc: {
      optimizer: {
          enabled: true,
          runs: 300
      }
  }
};