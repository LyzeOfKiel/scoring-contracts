pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {
    address public minter;

    constructor(address _minter) ERC20("RewardToken", "RWT") {
        minter = _minter;
    }

    function setMinter(address _minter) external onlyOwner {
        minter = _minter;
    }

    function isMinter(address _account) public view returns (bool) {
        return minter == _account;
    }

    function mint(address _to, uint256 _amount) external {
        require(isMinter(msg.sender), "ERC20Mint: not a minter");

        _mint(_to, _amount);
    }
}
