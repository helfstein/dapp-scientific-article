Quick start guide to initialize a new private network with Geth

# Setting up your Ethereum private Network
  
  ## Execute a new instance of console interactive JavaScript environment:
    geth --networkid 13 --port 60303 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpcapi="db,eth,net,web3,personal,web3" --lightkdf --cache 16 --datadir <node folder path (for exemple: 'C:\node1\data-private')> console
  
  ## Creating a new account on interactive JavaScript environment:
    personal.newAccount()

  ## Command to initialize mining into a private blockchain: 
    geth --identity nodeSOL --nodiscover --networkid 13 --port 60303 --maxpeers 10 --lightkdf --cache 16 --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain="*" --rpcapi="db,eth,net,web3,personal,web3" --unlock 0,1 --datadir <node folder path (for exemple: 'C:\node1\data-private')> --minerthreads 1 --mine

Reminders to be visible by MetaMask:

Argument below must be explicited informed on command: --rpc --rpcapi="db,eth,net,web3,personal,web3"

If you are trying to migrate a new contract to the private network and get the following erro: 'Running migration: 1_initial_migration.js Deploying Migrations... Migrations: 0xSomeAddress Saving successful migration to network... Error encountered, bailing. Network state unknown. Review successful transactions manually. Error: account is locked' You must unlock your geth account. Simply by putting '--unlock 0', where '0' represents your first account (coinbase) on Geth Wallet.

For more information go to: 
- Command Line Options: https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options 
- Mining: https://github.com/ethereum/go-ethereum/wiki/mining
- Managing your accounts: https://github.com/ethereum/go-ethereum/wiki/Managing-your-accounts
