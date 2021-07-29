// SPDX-License-Identifier: MIT

/* 
   Dev        :   BhaskarDutta
   Email      :   bhaskardutta2209@gmail.com
   LinkedIn   :   https://www.linkedin.com/in/bhaskar-dutta-6b23b616a/
*/

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Ecrianza is ERC721, Ownable {

    using SafeMath for uint256;

    string public ECR_PROVENANCE = "";

    uint256 public startingIndexBlock;

    uint256 public startingIndex;

    uint256 public constant nftPrice = 0.1 * 10**18; // 0.1 Ether

    uint public constant maxNftPurchase = 20;

    uint public MAX_NFT;

    bool public isSaleActive = false;

    uint256 public REVEAL_TIMESTAMP;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxNftSupply,
        uint256 saleStart
    ) ERC721(name, symbol) public {
        MAX_NFT = _maxNftSupply;
        REVEAL_TIMESTAMP = saleStart + (86400 * 9); // 86400 * no of days
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    // Keeping some NFTs aside
    function reserveNft(uint256 reserve) public onlyOwner {
        uint supply = totalSupply();
        uint counter;
        for (counter = 0; counter < reserve; counter++) {
            _safeMint(msg.sender, supply + counter);
        }
    }

    // Set a new REVEAL_TIMESTAMP
    function setReveealTimestamp(uint256 newTimestamp) public onlyOwner {
        REVEAL_TIMESTAMP = newTimestamp;
    }

    // Set provenance once it's calculated
    function setProvenance(string memory provenance) public onlyOwner {
        ECR_PROVENANCE = provenance;
    }

    // Set the base URI
    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    // Pause sale if active, make active if paused
    function flipSaleState() public onlyOwner {
        isSaleActive = !isSaleActive;
    }

    // The main minting function
    function mint(uint256 amount) public payable {
        require(isSaleActive, "Sale must be active to mint NFT");
        require(amount <= MAX_NFT, "Amount must be less than MAX_NFT");
        require(totalSupply().add(amount) <= MAX_NFT, "Total supply + amount must be less than MAX_NFT");
        require(nftPrice.mul(amount) == msg.value, "Ether value sent is not correct");

        for(uint counter = 0; counter < amount; counter++) {
            uint mintIndex = totalSupply();
            if(totalSupply() < MAX_NFT) {
                _safeMint(msg.sender, mintIndex);
            }
        }

        // If we haven't set the starting index and it is either
        // 1. the last saleable token or
        // 2. the first token to be sold after the end of pre-sale
        // set the starting index block
        if(startingIndexBlock == 0 && (totalSupply() == MAX_NFT || block.timestamp >= REVEAL_TIMESTAMP)) {
            startingIndexBlock = block.number;
        }
    }

    // Set the starting index for the collection
    function setStartingIndex() public {
        require(startingIndex == 0, "Starting Index is already set");
        require(startingIndexBlock != 0, "Starting index block must be set");

        startingIndex = uint(blockhash(startingIndexBlock)) % MAX_NFT;
        
        // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashess)
        if(block.number.sub(startingIndexBlock) > 255) {
            startingIndex = uint(blockhash(block.number -1 )) % MAX_NFT;
        }

        // Prevent default sequence
        if(startingIndex == 0) {
            startingIndex = startingIndex.add(1);
        }

    }

    // Set the starting index block for the collection, essentially unblocking setting starting index
    function emergencySetStartingIndex() public onlyOwner{
        require(startingIndex == 0, "Starting index is already set");

        startingIndexBlock = block.number;
    }

}