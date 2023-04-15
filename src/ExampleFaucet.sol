pragma solidity ^0.8.13;

import "./ScoreState.sol";
import "./RewardToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ExampleFaucet is Ownable {
	uint256 public constant FAUCET_VALUE = 1 ether;
	RewardToken public rewardToken;
    ScoreState public scoringSystem;
    uint256 public minScore;

    constructor(address _rewardToken, address _scoringSystem, uint256 _minScore) {
		rewardToken = RewardToken(_rewardToken);   
        scoringSystem = ScoreState(_scoringSystem);
        minScore = _minScore;
    }

    function setMinScore(uint256 _minScore) external onlyOwner {
        minScore = _minScore;
    }

	function claim(bytes32 root, uint256 score, bytes32[] calldata proof) external {
		address user = msg.sender;
        require(score >= minScore, "Score too low");
        ScoreState.Leaf memory leaf = ScoreState.Leaf(user, score);
        require(scoringSystem.verify(root, proof, leaf), "Invalid proof");
        rewardToken.mint(user, FAUCET_VALUE);
	}
}
