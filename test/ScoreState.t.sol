pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/ScoreState.sol";

contract ScoreStateTest is Test {
    ScoreState public scoreState;
    bytes32 public constant initRoot = keccak256("root0");

    function setUp() public {
        scoreState = new ScoreState(initRoot);
    }

    function testRootUpdate() public {
        bytes32 newRoot = keccak256("root1");
        assertEq(scoreState.checkRoot(initRoot), true);
        assertEq(scoreState.checkRoot(newRoot), false);

        vm.prank(0x1111111111111111111111111111111111111111);
        vm.expectRevert("Ownable: caller is not the owner");
        scoreState.updateRoot(newRoot);

        scoreState.updateRoot(newRoot);
        assertEq(scoreState.curTreeIndex(), 1);
        assertEq(scoreState.checkRoot(initRoot), true);
        assertEq(scoreState.checkRoot(newRoot), true);
        assertEq(scoreState.latestRoot(), newRoot);
    }

    function testHistory() public {
        uint32 rootIndex = 42;
        bytes32 root = keccak256(abi.encodePacked("root", rootIndex));
        scoreState.updateRoot(root);

        for (uint32 i = 0; i < scoreState.STATE_HISTORY_SIZE(); i++) {
            assertEq(scoreState.checkRoot(root), true);
            bytes32 newRoot = keccak256(
                abi.encodePacked("root", i + rootIndex + 1)
            );
            scoreState.updateRoot(newRoot);
        }
        // After `STATE_HISTORY_SIZE` updates, the `root` should be invalidated
        assertEq(scoreState.checkRoot(root), false);
    }

    function testVerify() public {
        bytes32 root = bytes32(
            0xd4dee0beab2d53f2cc83e567171bd2820e49898130a22622b10ead383e90bd77
        );
        scoreState.updateRoot(root);

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(
            0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc
        );

        ScoreState.Leaf memory leaf1 = ScoreState.Leaf({
            addr: address(0x1111111111111111111111111111111111111111),
            score: 5000000000000000001
        });

        assertEq(scoreState.verify(root, proof, leaf1), false);

        ScoreState.Leaf memory leaf2 = ScoreState.Leaf({
            addr: address(0x1111111111111111111111111111111111111111),
            score: 5000000000000000000
        });

        assertEq(scoreState.verify(root, proof, leaf2), true);
    }
}
