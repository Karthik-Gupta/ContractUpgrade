// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

contract VolcanoTokenUpgradeableV2 is Initializable, ERC721Upgradeable, OwnableUpgradeable, AccessControlUpgradeable, UUPSUpgradeable {
    uint constant public VERSION = 2;
    uint tokenId;
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    
    struct TokenMetadata {
        uint timestamp;
        uint tokenId;
        string tokenUri;
    }
    
    mapping(address => TokenMetadata[]) tokenOwnership;

    function initialize() public initializer {
        __Ownable_init();
        __UUPSUpgradeable_init();
        __ERC721_init("VolcanoToken", "VTK");

        _setupRole(UPGRADER_ROLE, msg.sender);
    }
    
    function getTokenOwnership(address _user) public view returns (TokenMetadata[] memory) {
        return tokenOwnership[_user];
    }
    
    function incrToken() internal returns (uint) {
        return tokenId++;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return "VolcanoToken/base";
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}
    
    function mintToken() public returns (uint) {
        uint _tokenId = incrToken();
        _safeMint(msg.sender, _tokenId);
        
        TokenMetadata memory data = TokenMetadata(block.timestamp, tokenId, "some uri data");
        
        tokenOwnership[msg.sender].push(data);
        
        return _tokenId;
    }
    
    function burnToken(uint _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not permitted with this operation!");
        _burn(_tokenId);
        _removeBurnedTokenFromOwnership(_tokenId, msg.sender);
    }
    
    function _removeBurnedTokenFromOwnership(uint _tokenId, address _tokenOwner) internal returns (bool) {
        for(uint i=0; i<tokenOwnership[_tokenOwner].length; i++) {
            if (tokenOwnership[_tokenOwner][i].tokenId == _tokenId) {
                delete tokenOwnership[_tokenOwner][i];
                return true;
            }
        }
        return false;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
}