// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.20;

struct Artifact {
    address owner;
    bytes32 codeHash;
    uint256 chainid;
    string link;
    string company;
    address[] related;
}

contract AuditRegistry {
    bytes32 constant EMPTY_HASH =
        0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    uint256 constant SUBMISSION_FEE = 0.1 ether;

    address public admin;
    mapping(address => Artifact[]) public registry;

    event Added(address owner, address target, bytes32 codeHash);
    event Removed(address owner, address target, bytes32 codeHash);
    event Withdrawal(address sender, address recipient, uint256 value);

    constructor() {
        admin = msg.sender;
    }

    function getCodeHash(address target) public view returns (bytes32) {
        bytes32 codeHash;
        assembly {
            codeHash := extcodehash(target)
        }
        return codeHash;
    }

    function codeHashMatches(address target) public view returns (bool) {
        bytes32 extHash = getCodeHash(target);
        Artifact[] memory artifactList = registry[target];

        uint256 i;
        for (i = 0; i < artifactList.length; i++) {
            if (artifactList[i].codeHash == extHash) {
                return true;
            }
        }
        return false;
    }

    function getArtifacts(
        address target
    ) public view returns (Artifact[] memory) {
        return registry[target];
    }

    function startsWith(
        string memory _prefix,
        string memory _candidate
    ) internal pure returns (bool) {
        bytes memory prefix = bytes(_prefix);
        bytes memory candidate = bytes(_candidate);

        uint8 i;
        for (i = 0; i < prefix.length; i++) {
            if (candidate[i] != prefix[i]) {
                return false;
            }
        }
        return true;
    }

    function add(
        address target,
        string calldata reportLink,
        string calldata company,
        address[] calldata related
    ) public payable {
        require(msg.value == SUBMISSION_FEE, "Invalid submission fee");
        require(
            startsWith("https://", reportLink) ||
                startsWith("ipfs://", reportLink),
            "Invalid report link prefix"
        );
        bytes32 code = getCodeHash(target);
        require(code != EMPTY_HASH, "No code at target address");

        Artifact memory a = Artifact({
            owner: msg.sender,
            codeHash: code,
            chainid: block.chainid,
            link: reportLink,
            company: company,
            related: related
        });
        registry[target].push(a);

        emit Added(msg.sender, target, code);
    }

    function remove(address target, uint256 index) public {
        Artifact[] storage artifactList = registry[target];
        require(index < artifactList.length, "Invalid artifact index");

        Artifact memory a = artifactList[index];
        require(a.owner == msg.sender, "Unauthorized action on artifact");

        // Move last element to deleted spot
        artifactList[index] = artifactList[artifactList.length - 1];
        artifactList.pop();

        emit Removed(msg.sender, target, a.codeHash);
    }

    function withdraw() public {
        uint256 balance = address(this).balance;
        (bool success, ) = admin.call{value: balance}("");
        require(success, "Failed to withdraw contract balance");
        emit Withdrawal(msg.sender, admin, balance);
    }
}
