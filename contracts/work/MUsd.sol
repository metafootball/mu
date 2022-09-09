// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MUsd is ERC20, Ownable {
    
    uint256 private constant MINTING_PERIOD = 1 hours;
    uint256 public mintingIncrease;
    uint256 public lastMintTime;

    mapping(address => bool) public administrator;
    mapping(address => bool) public blacklist;

    modifier onlyAdmin() {
        require(administrator[_msgSender()], "caller not Admin");
        _;
    }

    constructor(address mintTo) ERC20("Meer USD", "USDT") {
        mintingIncrease = 1_000_000 ether;
        lastMintTime = block.timestamp;
        _mint(mintTo, 10_000_000 ether);
    }

    function setAdmin(address admin, bool qualifications) external onlyOwner {
        administrator[admin] = qualifications;
    }

    function setBlacklist(address sender, bool isBlack) external onlyAdmin {
        blacklist[sender] = isBlack;
    }

    function setIncrease(uint _mintingIncrease) external onlyAdmin {
        mintingIncrease = _mintingIncrease;
    }

    function mint(address to, uint256 amount) public onlyAdmin {
        require(lastMintTime + MINTING_PERIOD <= block.timestamp, "not thawed");
        require(mintingIncrease >= amount, "mint overflow");
        _mint(to, amount);
        lastMintTime = block.timestamp;
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function _beforeTokenTransfer( address from, address to, uint) internal view override {
        require(!(blacklist[from] || blacklist[to]), "no transaction");
    }
}
