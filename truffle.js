var HDWalletProvider = require("truffle-hdwallet-provider");
var infura_apikey = "JkrmaMjx2Q9kIQ95ydgl";
var mnemonic = "rude bright planet anchor cousin shadow laptop tribe oval purchase tower small";
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      // provider: new HDWalletProvider(mnemonic, "https://ropsten.infura.io/" + infura_apikey),
	  provider: new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/" + infura_apikey),
      // provider: new HDWalletProvider(mnemonic, "https://kovan.infura.io/" + infura_apikey),
      network_id: "3"
	}
  }
};
// module.exports = {
  // networks: {
    // development: {
      // host: "localhost",
      // port: 8545,
      // network_id: "*" // Match any network id
    // },
	// ropsten: {
      // host: 'localhost', // Connect to geth on the specified
      // port: 8545,
      // from: '0xabcde12345', // default address to use for any transaction Truffle makes during migrations
      // network_id: 4,
      // gas: 6612388, // Gas limit used for deploys
      // gasPrice: 2700000000000,
	// }
  // }
// };