pragma solidity ^0.8.0;
contract CrazyWhales is Ownable, ERC721URIStorage, VRFConsumerBase {
    using SafeMath for uint256;
    using Strings for uint256;
    using EnumerableSet for EnumerableSet.UintSet;

    address private _paymentAddress = 0x000000000000000000000000000000000000dEaD;
    address public gainsTokenAddress;  
    
    bool private _isActive = false;

    uint256 public constant WHALES_MAX = 3000;
    uint256 public maxCountPerClaim = 100;
    uint256 public pricePerWhales = 500 * 1e18;

    uint256 public totalMinted = 0;

    string private _tokenBaseURI = "";

    struct ClaimRequest {
        address account;
        uint256 count;
        bool    active;
    }

    mapping(bytes32 => ClaimRequest) private _vrfRequests;
    EnumerableSet.UintSet private _whalesPool;
    
    bytes32 internal vrfKeyHash;
    uint256 internal vrfFee;


    event Claimed(address account, uint256 times, bytes32 requestId);


    modifier onlyActive() {
        require(_isActive && totalMinted < WHALES_MAX, 'CrazyWhales: not active');
        _;
    }

    constructor() ERC721("CrazyWhales", "CW") VRFConsumerBase(
            0x3d2341ADb2D31f1c5530cDC622016af293177AE0, // VRF Coordinator
            0xb0897686c545045aFc77CF20eC7A532E3120E0F1  // LINK Token
        ) { 
        vrfKeyHash = 0xf86195cf7690c55907b2b611ebb7343a6f649bff128701cc542f0569e2c549da;
        vrfFee = 0.0001 * 10 ** 18; // 0.0001 LINK

        gainsTokenAddress = 0xb585cAeA456F475244A84f32671B7648afD82F91;
    }

    function claim(uint256 numberOfTokens) external onlyActive {
        require(numberOfTokens > 0, "CrazyWhales: zero count");
        require(numberOfTokens <= maxCountPerClaim, "CrazyWhales: exceeded max limit per claim");
        require(numberOfTokens <= remainPunks(), "CrazyWhales: not enough whales");
        
        
        // request random number to ChainLInk
        bytes32 requestId = _getRandomNumber();
        _vrfRequests[requestId].account = msg.sender;
        _vrfRequests[requestId].count = numberOfTokens;
        _vrfRequests[requestId].active = true;
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        ClaimRequest memory request = _vrfRequests[requestId];
        require(request.active, "Invalid request");
        require(request.count > 0, "Invalid request count");

        uint256 times = request.count;
        address account = request.account;

        uint256[] memory randomNumbers = expandRandomNumber(randomness, times);
        
        require(IERC20(gainsTokenAddress).transferFrom(account, _paymentAddress, times.mul(pricePerWhales)), "CrazyWhales: failed to transfer gains");

        for (uint256 i = 0; i < times; i++) {
            uint256 remainCount = _whalesPool.length();
            uint256 randomId =  _whalesPool.at(randomNumbers[i].mod(remainCount));
            
            _safeMint(account, randomId);
            super._setTokenURI(randomId, randomId.toString());

            totalMinted = totalMinted.add(1);
            _whalesPool.remove(randomId);
        }

        emit Claimed(account, times, requestId);

        _vrfRequests[requestId].active = false;
    }

    /** 
     * Requests randomness from a user-provided seed
     */
    function _getRandomNumber() private returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= vrfFee, "Not enough LINK ");
        return requestRandomness(vrfKeyHash, vrfFee);
    }

    function expandRandomNumber(uint256 randomValue, uint256 n) private pure returns (uint256[] memory expandedValues) {
        expandedValues = new uint256[](n);
        for (uint256 i = 0; i < n; i++) {
            expandedValues[i] = uint256(keccak256(abi.encode(randomValue, i)));
        }
        return expandedValues;
    }

    function remainPunks() public view returns(uint256) {
        return WHALES_MAX.sub(totalMinted);
    }

    function price() public view returns(uint256) {
        return pricePerWhales;
    }

    function _baseURI() internal view override returns (string memory) {
        return _tokenBaseURI;
    }

    function tokenURI(uint256 tokenId) public view override(ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
    
    /////////////////////////////////////////////////////////////
    //////////////////   Admin Functions ////////////////////////
    /////////////////////////////////////////////////////////////

    function initWhalesPool(uint256 count) public onlyOwner {
        // init whales pool
        uint256 currentTotal = _whalesPool.length();
        require(currentTotal.add(count) <= WHALES_MAX, "too many");

        for(uint i = currentTotal; i < currentTotal + count ; i++) {
            _whalesPool.add(i + 1);
        }
    }


    function setActive(bool isActive) external onlyOwner {
        _isActive = isActive;
    }

    function setTokenBaseURI(string memory URI) external onlyOwner {
        _tokenBaseURI = URI;
    }

    function setpricePerWhales(uint _price) external onlyOwner {
        pricePerWhales = _price;
    }

    function setMaxCountPerClaim(uint _count) external onlyOwner {
        maxCountPerClaim = _count;
    }

    function setGainsTokenAddress(address _address) external onlyOwner {
        gainsTokenAddress = _address;
    }

    function withdrawLINK() public onlyOwner {
        uint256 balance = LINK.balanceOf(address(this));
        require(balance > 0, 'Insufficient LINK Token balance');
        LINK.transfer(owner(), balance);
    }
}