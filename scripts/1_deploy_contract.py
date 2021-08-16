from brownie import GambaKittiesClub, accounts, network, config

def main():
    dev = accounts.add(config['wallets']['from_key'])
    print(network.show_active())
    publish_source = True
    GambaKittiesClub.deploy(
        "Gamba Kitties Club",
        "GKC",
        10000,
        1628588441, # Sale start time
        {"from": dev},
        publish_source = publish_source
    )
