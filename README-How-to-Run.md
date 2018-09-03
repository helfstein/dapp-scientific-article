# PocDApp
## To run this project follow the steps below
First we'll need to instal dependencies for truffle template, angular and etherum-bridge

## 1 - Install dependencies for etherum-bridge
```sh
$ cd etherumbridgenode
$ npm install
```
## 2 - Install dependencies for truffle template 
```sh
$ cd ..
$ cd src
$ npm install
```
## 3 - Install dependencies for angular project
```sh
$ cd dapp
$ npm install
```
## 4 - Edit truffle.js file located in "src" folder to point to etherum node like Ganache geth or truffle develop. The code sample is below.
```javascript
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
```
## 5 - Run your etherun node, in my case i'm using ganache, the link to download ganache for windows is below
[Downdload Ganache for Windows](https://truffleframework.com/ganache)

## 6 - Run your etherum bridge executing the below commands
```sh
$ cd etherumbridgenode
$ node bridge -a 2 -H 127.0.0.1 -p 7545
```
Note parameter -a indicates the account that gas will is used for deploy oraclize contract, -H indicates de etherum node ip and -p the port

### Note: If you are using Geth as your Ethereum Client, you must remember to initialize the private network with the following command:
```sh
geth --identity nodeSOL --nodiscover --networkid 13 --port 60303 --maxpeers 10 --lightkdf --cache 16  --rpc --rpcport 8545 --rpcaddr 127.0.0.1 --rpccorsdomain="*" --rpcapi="db,eth,net,web3,personal,web3" **--unlock 0** --datadir "C:\ETH\data-private" --minerthreads 1  --mine
```
Where the **--unlock** parameter is super important to make sure that your Oraclize contract on the Ethereum-bridge will deploy sucessfully into your private network. (the number informed after the unlock parameter is the index position from your accounts that you want to unlock from Geth).\
Note: --datadir "C:\ETH\data-private" its just a specified location where I create the node files in my local machine, feel free to create in another path.

## 7 - Set the address of oraclize resolver interface in your contract that uses the oraclize calls
* Edit 2_deploy_contracts.js file changing the value "0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475" by the OAR printed in console in previous step.

Note OAR address is printed like this: OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)

## 8 - Now we'll compile and migrate our contract. So let's ope another prompt or powershell window and go to the folder using below commands
```sh
$ cd src
$ truffle migrate --compile all --reset
```
## 9 - In this step we'll run our angular front-end to communicate with etherum rpc using Metamask and Web3. But first we need to open another prompt or terminal and go to angular folder, then we can start the http server to provide our front-end to the browser. Let's type more commands.
```sh
$ cd src
$ cd dapp
$ ng serve -o
```