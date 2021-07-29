from brownie import Ecrianza, accounts, network, config

def main():
    dev = accounts.add(config['wallets']['from_key'])
    print(network.show_active())
    publish_source = False
    Ecrianza.deploy(
        "Ecrianza",
        "ECR",
        100,
        1627483885,
        {"from": dev},
        publish_source = publish_source
    )
