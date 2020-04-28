# Welcome to the PROTON MainNet [manual node installation]

Chain ID:  384da888112027f0321850a169f737c33e53b388aad48b5adace4bab97f437e0
Based on tag: 2.0.5

Please join out PROTON MainNet <a target="_blank" href="https://t.me/">Telegram channel</a>  
Network Monitor: https://monitor.protonchain.com/  


! This repo is for manual installation.  


To start a PROTON MainNet node you need install EOSIO software. You can compile from sources or install from precompiled binaries:  

# 1. Installing EOSIO  
---------------------------------------------------  

# 1.1 EOSIO - Installing from sources  

A. Create folder, download sources, compile and install:  

```
mkdir /opt/EOSIO  
cd /opt/EOSIO  

git clone https://github.com/eosio/eos --recursive    
cd eos  

git checkout v2.0.5  
git submodule update --init --recursive   

./scripts/eosio_build.sh -P -y
./scripts/eosio_install.sh
```  

B. Copy binaries to keep old versions and make sym link to latest:  

```
mkdir /opt/bin
mkdir /opt/bin/v2.0.5
cp /opt/EOSIO/eos/build/programs/nodeos/nodeos /opt/bin/v2.0.5/
cp /opt/EOSIO/eos/build/programs/cleos/cleos /opt/bin/v2.0.5/
cp /opt/EOSIO/eos/build/programs/keosd/keosd /opt/bin/v2.0.5/
ln -sf /opt/bin/v2.0.5 /opt/bin/bin
```

So /opt/bin/bin will point to latest binaries  


# 1.2 EOSIO - installing from precompiled binaries  

A. Download the latest version of EOSIO for your OS from:  
https://github.com/EOSIO/eos/releases/tag/v2.0.5   
For example, for ubuntu 18.04 you need to download deb eosio_2.0.5-1-ubuntu-18.04_amd64.deb              
To install it you can use apt:  
```
apt install ./eosio_2.0.5-1-ubuntu-18.04_amd64.deb
```
It will download all dependencies and install EOSIO to /usr/opt/eosio/v2.0.5  
B. Copy binaries to keep old versions and make sym link to latest:  

```
 mkdir /opt/bin
 mkdir /opt/bin/v2.0.5
 cp /usr/opt/eosio/v2.0.5/bin/nodeos /opt/bin/v2.0.5/
 cp /usr/opt/eosio/v2.0.5/bin/cleos /opt/bin/v2.0.5/
 cp /usr/opt/eosio/v2.0.5/bin/keosd /opt/bin/v2.0.5/
 ln -sf /opt/bin/v2.0.5/ /opt/bin/bin
```

So /opt/bin/bin will be point to latest binaries  

---------------------------------------------------------  
# 2. Update EOSIO software to new version  

# 2.1 Update sources  

```
cd /opt/EOSIO/eos
git checkout -f
git branch -f
git pull
git checkout v2.0.5
git submodule update --init --recursive


./scripts/eosio_build.sh -P -y
./scripts/eosio_uninstall.sh
./scripts/eosio_install.sh

mkdir /opt/bin/v2.0.5
cp /opt/EOSIO/eos/build/programs/nodeos/nodeos /opt/bin/v2.0.5/
cp /opt/EOSIO/eos/build/programs/cleos/cleos /opt/bin/v2.0.5/
cp /opt/EOSIO/eos/build/programs/keosd/keosd /opt/bin/v2.0.5/
ln -sf /opt/bin/v2.0.5 /opt/bin/bin
```  

# 2.2 Update binaries  
To upgrade precompiled installation pleasse folow the same steps as in 1.2 (Installation from precompiled)  

------------------------------------------------------------------  

# 3. Install PROTON MainNet node [manual]  
    
```
    mkdir /opt/ProtonMainNet
    cd /opt/ProtonMainNet
    git clone https://github.com/ProtonProtocol/proton.start.git ./

```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

- The first thing you will need to do is download the Wallet(the link will be soon) and create a new PROTON mainnet account.

- To register as Block Producer you should go to the <a target="_blank" href="https://permission.protonchain.com/">Permission Portal</a> login and request permission to regproduse  
  when you got this permission and you finish prepare node you can run command 
  ```
  ./cleos.sh system regproducer YOU_ACCOUNT PUBKEY "URL" LOCATION -p YOU_ACCOUNT
  ```

- If non BP node: use the same config, just comment out rows with producer-name and signature-provider  
  
- Edit config.ini:  
  - server address: p2p-server-address = ENRT_YOUR_NODE_EXTERNAL_IP_ADDRESS:9876  

  - if BP: your producer name: producer-name = YOUR_BP_NAME  
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action):  
  signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE  
  - replace p2p-peer-address list with fresh generated on monitor site: https://monitor.protonchain.com/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  
  
- Open TCP Ports (8888, 9876) on your firewall/router  


- Start wallet, run  
```
cd /opt/ProtonMainNet
./Wallet/start_wallet.sh
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
cd /opt/ProtonMainNet/protonNode
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --to-file pass.tx
```
Your password will be in pass.txt it will be used when unlock wallet  


- Unlock your wallet  
```
./cleos.sh wallet unlock
```
enter the wallet password.  


- Import your key  
```
./cleos.sh wallet import
```
Enter your private key  



- Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="http://proton.cryptolions.io/v1/chain/get_info" target="_blank">Example</a>)  


==============================================================================================  

# 4.1 Restore/Start from Backup
   Download latest block and state archive for your OS from http://backup.cryptolions.io/ProtonMainNet/
   
   ```
   wget http://backup.cryptolions.io/ProtonMainNet/ubuntu18/latest-blocks.tar.gz
   wget http://backup.cryptolions.io/ProtonMainNet/ubuntu18/latest-state.tar.gz
   ```
   After downloaded extract their
   ```
   tar xzvf blocks-latest.tar.gz -C .
   tar xzvf state-latest.tar.gz -C .
   ```
   You got two folders block and state.  
   Ater that go to **NODE** folder, and remove files from folder blocks and state
   ```
   cd /opt/ProtonMainNet/protonNode
   rm blocks/*
   rm state/*
   ```
   After that go where you extracted archive and move file from folder 
   ```
   mv ~/blocks/* /opt/ProtonMainNet/protonNode/blocks/
   mv ~/state/* /opt/ProtonMainNet/protonNode/state/
   ```
   After files moved start your NODE
   ```
   ./start.sh
   ```
# 4.2 Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/ProtonMainNet/snapshots/ to snapshots folder in your **NODE** directory
   ```
   cd /opt/protonMainNet/protonNode/snapshots/
   wget http://backup.cryptolions.io/ProtonMainNet/snapshots/latest-snapshot.bin
   ```
   after it downloaded run `start.sh` script with option `--snapshot` and snapshot file path
   ```
   cd /opt/ProtonMainNet/protonNode
   ./start.sh --snapshot /opt/ProtonMainNet/protonNode/snapshots/latest-snapshot.bin
   ```
 ---

# Other Tools/Examples  

- Cleos commands:  

Send XPR
```
./cleos.sh transfer <your account> <receiver account> "1.0000 XPR" "test memo text"
```
Get Balance  
```
./cleos.sh get currency balance eosio.token <account name>
```
Create account  
```
./cleos.sh system newaccount --stake-net "10.0000 XPR" --stake-cpu "10.0000 XPR" --buy-ram-bytes 4096 <your accountr> <new account> <pkey1> <pkey2>
```  
List registered producers (-l <limit>)  
```
./cleos.sh get table eosio eosio producers -l 100
```
List your last action (use -h to get help, do not work now, works with history node only)  
```
./cleos.sh get actions <account name>
```
  
List staked/delegated  
```
./cleos.sh system listbw <account>
```

## PROTON API
```
https://proton.cryptolions.io
https://api-proton.eosarabia.net
https://proton.eos.barcelona
https://proton.pink.gg
https://proton.lynxsweden.org
https://proton.eosdublin.io
https://api.proton.alohaeos.com
https://proton.eosphere.io
https://proton.eosvenezuela.io
https://api.proton.eostribe.io
http://proton.greymass.com
```

**Network Monitor**
https://monitor.protonchain.com/
 
**Hyperion History**  
https://proton.cryptolions.io/v2/docs  
https://proton.eosusa.news/v2/docs/index.html

**Block Explorers**   
https://proton.bloks.io/  

**Permissions**    
https://permission.protonchain.com

--------------  

# Backups
### Full(blocks and states):
  * [Ubuntu 18](http://backup.cryptolions.io/ProtonMainNet/ubuntu18/)  
  
### Snapshot:
  * [Snapshots](http://backup.cryptolions.io/ProtonTestnet/snapshots/)

--------------
