# GambaKitttiesClub

"In the loving memory of my father, Late Sankar Dutta"

Dev      : Bhaskar Dutta
Email    : bhaskardutta2209@gmail.com
Linkedin : https://www.linkedin.com/in/bhaskar-dutta-6b23b616a/

## How to deploy
- Modity the 1_deploy_control.py file in scripts folder
  -  Put the UNIX time to start sale
- Create .env or rename .env.example to .env
  -  Put wallet private key which have Eth for deployment
  -  Put WEB3_INFURA_PROJECT_ID for ethereum mainnet
  -  Put ETHERSCAN_TOKEN to show contract code on etherscan
- source .env
- brownie run scripts/1_deploy_control.py --network mainnet