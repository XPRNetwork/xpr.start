# Welcome to the XPR Network MainNet [Validator Node Installation]

Chain ID: `384da888112027f0321850a169f737c33e53b388aad48b5adace4bab97f437e0` 
Based on tag: 4.0.4

Please join our [XPR Network Testnet Telegram channel](https://t.me/XPRNetwork/935112)
MainNet Explorer: https://explorer.xprnetwork.org/

This repo is for binary installation!

**XPR Network is a protocol built on top of the Antelope (EOSIO) consensus layer that allows verified user identity and applications to generate signature requests (transactions) that can be pushed to signers (wallets) for authentication and signature creation. These signature requests can be used today to authenticate and sign cryptographic payments. The same architecture will be used in future version to initiate and track pending fiat transactions**

To start a XPR Network node you need install Leap software. You can compile from sources or install from precompiled binaries:  

## Important Update

> [!IMPORTANT] 
> XPR Network Consortium is requesting all Block Producers to update their nodes to the latest version of Leap (4.0.4) by 30 October 2023. This update is required to ensure the stability of the XPR Network MainNet.

Please contact us on Telegram if you have any questions: [https://t.me/XPRNetwork/935112](https://t.me/XPRNetwork/935112)

---------------------------------------------------  

Make sure you have Ubuntu 22.04 installed. (Check OS version by using this command `lsb_release -a`)

# 1. Installing from precompiled binaries

A. Download the latest version of Antelope Leap for your OS from:
[https://github.com/AntelopeIO/leap/releases/tag/v4.0.4
](https://github.com/AntelopeIO/leap/releases/tag/v4.0.4)

For example, for Ubuntu 22.04 you need to download deb leap_4.0.4-ubuntu22.04_amd64.deb, note that Ubuntu 18.04 will not be any more supported in Leap.

To install it you can use apt, but before that download it using wget command:
```
wget https://github.com/AntelopeIO/leap/releases/download/v4.0.4/leap_4.0.4-ubuntu22.04_amd64.deb && apt install ./leap_4.0.4-ubuntu22.04_amd64.deb 
```
It will download all dependencies and install Leap  

---------------------------------------------------------  
# 2. Update software to new version  

If upgrading from old 2.X or 3.X versions please see this important guide 
https://eosnetwork.com/blog/leap-3-1-upgrade-guide/

```
apt install ./leap_4.0.4-ubuntu22.04_amd64.deb 
```

------------------------------------------------------------------  

# 3. Install XPR Network MainNet node [manual]  
    
```
mkdir /opt/XPRMainNet && cd /opt/XPRMainNet && git clone https://github.com/XPRNetwork/xpr.start.git ./
```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

- NODEOSBINDIR="/usr/bin"

-  to create an account on XPR Network go to <a target="_blank" href="https://webauth.com/">WebAuth.com</a> create your account, use a real email to get verification code. You can get your private key by going to settings > backup private key.


- If non BP node: use the same config, just comment out rows with producer-name and signature-provider  
  
- Edit config.ini:  
  - server address: `p2p-server-address = EXTERNAL_IP_ADDRESS:9876` 

  - if BP: your producer name: `producer-name = YOUR_BP_NAME`
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action, use this command `cleos create key --to-console`, and enter PUB key PRIV key in signature-provider): `signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE` 
  - replace p2p-peer-address list with fresh generated on monitor site: https://monitor.protonchain.com/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM: `chain-state-db-size-mb = 16384`
  - set CPU governor to performance, first check current CPU governor by using this command `cpufreq-info` and then set to performance `sudo cpufreq-set -r -g performance`
  - use this command to watch current CPU clock speed `watch -n 0.4 "grep -E '^cpu MHz' /proc/cpuinfo"`
  
- Open TCP Ports (8888, 9876) on your firewall/router

- Start wallet, run  
```
cd /opt/XPRMainNet && ./Wallet/start_wallet.sh
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
cd /opt/XPRMainNet/xprNode && ./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok.
```
tail -f stderr.txt
```

- Create your wallet file  
```
cleos wallet create --to-file pass.tx
```
Your password will be in pass.txt it will be used when unlock wallet


- Unlock your wallet  
```
cleos wallet unlock
```
enter the wallet password.  


- Import your key  
```
cleos wallet import
```
Enter your private key  


- Check if you can access your node using following URL: http://you_server:8888/v1/chain/get_info (<a href="https://proton.cryptolions.io/v1/chain/get_info" target="_blank">Example</a>)  


==============================================================================================  

# 4. Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/ProtonMainNet/snapshots/ to snapshots folder in your **NODE** directory
   ```
   mkdir /opt/XPRMainNet/xprNode/snapshots
   cd /opt/XPRMainNet/xprNode/snapshots/
   wget http://backup.cryptolions.io/ProtonMainNet/snapshots/latest-snapshot.bin.zst
   ```
   after it downloaded, extract and copy to /snapshots then run `start.sh` script with option `--snapshot` and snapshot file path
   ```
   sudo apt-get install zstd
   unzstd latest-snapshot.zst
   cd /opt/XPRMainNet/xprNode
   ./start.sh --snapshot /opt/XPRMainNet/xprNode/snapshots/latest-snapshot.bin
   ```
 ---
# 5. Usefull Information  

# XPR Network Faucet - get free XPR tokens:  
  [https://resources.xprnetwork.org/faucet](https://resources.xprnetwork.org/faucet)  

# Other Tools/Examples  

- Cleos commands:  

Send XPR
```
cleos transfer <your account> <receiver account> "1.0000 XPR" "test memo text"
```
Get Balance  
```
cleos get currency balance eosio.token <account name>
```
Create account  
```
cleos system newaccount --stake-net "10.0000 XPR" --stake-cpu "10.0000 XPR" --buy-ram-bytes 4096 <your accountr> <new account> <pkey1> <pkey2>
```  
List registered producers (-l <limit>)  
```
cleos get table eosio eosio producers -l 100
```
List your last action (use -h to get help, do not work now, works with history node only)  
```
cleos get actions <account name>
```
  
List staked/delegated  
```
cleos system listbw <account>
```
## XPR Network MAINNET P2P

```
api.protonnz.com:9876
proton.protonuk.io:9876
proton.p2p.eosusa.io:9879
proton.cryptolions.io:9876
main.proton.kiwi:9786
protonp2p.eoscafeblock.com:9130
p2p.alvosec.com:9876
p2p.protonmt.com:9876
p2p.totalproton.tech:9831
mainnet.brotonbp.com:9876
proton.eu.eosamsterdam.net:9103
protonp2p.blocksindia.com:9876
p2p-protonmain.saltant.io:9876
protonp2p.ledgerwise.io:23877
proton-seed.eosiomadrid.io:9876
proton.edenia.cloud:9879
proton.genereos.io:9876
peer-proton.nodeone.network:9870
p2p.proton.eoseoul.io:39876
proton-public.neftyblocks.com:19876
p2p-proton.eosarabia.net:9876
```

## XPR Network MAINNET API
```
https://api.protonnz.com
https://proton.protonuk.io
https://proton.eosusa.io
https://proton.cryptolions.io
https://main.proton.kiwi
https://proton.eoscafeblock.com
https://proton-api.alvosec.com
https://api.protonmt.com
https://api.totalproton.tech
https://mainnet.brotonbp.com
https://proton.eu.eosamsterdam.net
https://protonapi.blocksindia.com
https://aa-proton.saltant.io
https://protonapi.ledgerwise.io
https://proton.api.atomicassets.io
https://proton.pink.gg
https://proton-api.eosiomadrid.io
https://proton.edenia.cloud
https://proton.genereos.io
https://api-proton.nodeone.network:8344
https://proton.eoseoul.io
https://proton-public.neftyblocks.com
https://api-proton.eosarabia.net
```

# 6. Usefull Links

**Hyperion History**  
https://proton.cryptolions.io/v2/docs  
https://proton.eosusa.news/v2/docs/index.html  
https://proton-hyperion.eoscafeblock.com/v2/docs/index.html
https://api-protontest.saltant.io/v2/docs/static/index.html
http://proton-api-testnet.eosiomadrid.io/v2/docs/static/index.html


**Block Explorers**   
https://explorer.xprnetwork.org

--------------  

# Backups
 
### Snapshot:
  * [Snapshots](http://backup.cryptolions.io/ProtonMainNet/snapshots/)

--------------
