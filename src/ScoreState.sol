pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ScoreState is Ownable {
    mapping(uint256 => bytes32) public roots;
    uint32 public constant STATE_HISTORY_SIZE = 5;
    uint32 public curTreeIndex = 0;

    struct Leaf {
        address addr;
        uint256 score;
    }

    constructor(bytes32 root) {
        roots[0] = root;
    }

    function updateRoot(bytes32 root) external onlyOwner {
        uint32 rootIndex = (curTreeIndex + 1) % STATE_HISTORY_SIZE;
        roots[rootIndex] = root;
        curTreeIndex++;
    }

    function verify(
        bytes32 root,
        bytes32[] calldata proof,
        Leaf calldata leaf
    ) external view returns (bool) {
        require(checkRoot(root), "Unknown root");
        bytes32 leafHash = hashLeaf(leaf);
        // `verifyCalldata` is a cheaper version of `verify`
        return MerkleProof.verifyCalldata(proof, root, leafHash);
    }

    function checkRoot(bytes32 root) public view returns (bool) {
        if (root == 0) {
            return false;
        }
        for (uint32 j = 0; j < STATE_HISTORY_SIZE; j++) {
            uint32 index = curTreeIndex - j;
            if (root == roots[index]) {
                return true;
            }
            if (index == 0) {
                break;
            }
        }
        return false;
    }

    function latestRoot() public view returns (bytes32) {
        return roots[curTreeIndex];
    }

    function hashLeaf(Leaf calldata leaf) internal pure returns (bytes32) {
        return
            keccak256(
                bytes.concat(keccak256(abi.encode(leaf.addr, leaf.score)))
            );
    }
}
