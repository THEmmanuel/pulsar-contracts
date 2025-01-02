## PULSAR CONTRACTS

### pulsar
- Contract for the $pulsar token

### transferWithFee
- Contract for transferring tokens with a 5% charge sent to a reserve wallet and the recipient wallet with one txn.

### SimplePaymaster
- A paymaster contract leveraging on erc-4337 for gas sponsorship for users. (compiles and deploys but needs optimization etc)

# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat ignition deploy ./ignition/modules/Lock.js
```
