// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MetaChain
 * @dev A decentralized platform for managing digital asset ownership in the Metaverse.
 *      This contract allows users to register, verify, and transfer ownership of unique assets.
 */
contract MetaChain {
    address public owner;
    uint256 public assetCount = 0;

    struct Asset {
        uint256 id;
        string name;
        string metadataURI;
        address currentOwner;
    }

    mapping(uint256 => Asset) public assets;

    event AssetRegistered(uint256 indexed id, string name, address indexed owner);
    event OwnershipTransferred(uint256 indexed id, address indexed from, address indexed to);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Register a new digital asset on MetaChain
     * @param _name Name of the asset
     * @param _metadataURI Link to the metadata (IPFS, Arweave, etc.)
     */
    function registerAsset(string memory _name, string memory _metadataURI) external {
        assetCount++;
        assets[assetCount] = Asset(assetCount, _name, _metadataURI, msg.sender);
        emit AssetRegistered(assetCount, _name, msg.sender);
    }

    /**
     * @notice Transfer ownership of an asset to another user
     * @param _assetId ID of the asset
     * @param _newOwner Address of the new owner
     */
    function transferOwnership(uint256 _assetId, address _newOwner) external {
        Asset storage asset = assets[_assetId];
        require(asset.currentOwner == msg.sender, "You are not the owner");
        require(_newOwner != address(0), "Invalid address");

        address previousOwner = asset.currentOwner;
        asset.currentOwner = _newOwner;

        emit OwnershipTransferred(_assetId, previousOwner, _newOwner);
    }

    /**
     * @notice Retrieve details of a specific asset
     * @param _assetId ID of the asset
     * @return name, metadataURI, currentOwner
     */
    function getAsset(uint256 _assetId)
        external
        view
        returns (string memory, string memory, address)
    {
        Asset memory asset = assets[_assetId];
        return (asset.name, asset.metadataURI, asset.currentOwner);
    }
}

