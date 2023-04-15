pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ScoreState.sol";
import "../src/RewardToken.sol";
import "../src/ExampleFaucet.sol";

contract ExampleFaucetTest is Test {
    ScoreState public scoreState;
    ExampleFaucet public exampleFaucet;
    RewardToken public rewardToken;

    function setUp() public {
        scoreState = new ScoreState(keccak256("root0"));
        rewardToken = new RewardToken(address(this));
        exampleFaucet = new ExampleFaucet(
            address(rewardToken),
            address(scoreState),
            10
        );
        rewardToken.setMinter(address(exampleFaucet));
    }

    function testClaim() public {
        bytes32 root = bytes32(
            0xd4dee0beab2d53f2cc83e567171bd2820e49898130a22622b10ead383e90bd77
        );
        scoreState.updateRoot(root);

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(
            0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc
        );

        address user = 0x1111111111111111111111111111111111111111;
        uint256 score = 5000000000000000000;

        vm.prank(user);
        vm.expectRevert("Invalid proof");
        exampleFaucet.claim(root, score + 1, proof);

        vm.prank(user);
        exampleFaucet.claim(root, score, proof);
        assertEq(rewardToken.balanceOf(user), exampleFaucet.FAUCET_VALUE());
    }
}
