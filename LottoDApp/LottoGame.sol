
pragma solidity ^0.6.12;

//https://etherscan.io/token/0x816ce692734e5ad638926a66c2879f0614132f01
//https://testnet.bscscan.com/address/0xebbf72de4999e4a4ff7d3bd63532fd19d5a87171#code


interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    
    function balanceOf(address account) external view returns (uint256);

    
    function transfer(address recipient, uint256 amount) external returns (bool);

    
    function allowance(address owner, address spender) external view returns (uint256);

  
    function approve(address spender, uint256 amount) external returns (bool);

   
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

   
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
/*
Lotto pool interface
*/
interface  ILotto{

function createPool(uint participants,uint minimumContribution)external returns(bool);
function joinPool(uint poolId,uint amount) external returns(bool);
function pickWinnerFromPool(uint id) external returns(address _winner);

function PoolInfobyId(uint PoolId) external view returns(uint _poolId,uint _totalparticipants, uint _maxParticipants,uint _minimumContribution,uint _creationTime);
event PoolCreated(uint indexed poolId, address  creater, uint participants,uint contribution);
event poolDraw(uint indexed PoolId, address winner, uint winningAmount);
event ReceicedSubscription(uint poolId, address subscriber,uint amount,uint indexed participantId);
}

contract Context {
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; 
    return msg.data;
  }
  
}
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }


  function owner() public view returns (address) {
    return _owner;
  }


  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }


  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }


  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}
contract lottoGame  {
    using SafeMath for uint;
    struct LottoPool{
        uint _poolId;
        address _creator;
        uint _participantcounter;
        uint _maxParticipants;
        uint _minimumContribution;
     //   uint _currentParticipants;
        uint _timestamp;
        mapping(uint=>address) _participants;
    }
    //events
    event PoolCreated(uint indexed poolId, address  creater, uint participants,uint contribution);
event poolDraw(uint indexed PoolId, address winner, uint winningAmount);
event ReceivedSubscription(uint poolId, address subscriber,uint amount,uint indexed participantId);
    // state variables
    mapping  (uint=>LottoPool) public poolById;
    mapping (uint=>uint) public fundsbyPool;
    IERC20 public _Token;
    uint public poolCounter=0;
    uint[] public pools;
     uint public duration;  
    constructor(address token)public{
        _Token= IERC20(token);
        duration = 1 days ;
       
        
    }
    modifier onlyNewPartipant(uint poolId,address newparticipant){
        LottoPool memory pool=poolById[poolId];
        uint participants= pool._participantcounter;
        for(uint i=0; i<=participants;i++ ){
            require(poolById[poolId]._participants[i]!=newparticipant,"paticipant already Exist in Pool" );
        }
        _;
        }
    function createPool(uint participants,uint minimumContribution)external returns(bool){
       
poolCounter=poolCounter.add(1);
poolById[poolCounter]=LottoPool(poolCounter,msg.sender,0,participants,minimumContribution,block.timestamp);
//poolById[poolCounter].participants[0]=address(0);
pools.push(poolCounter);
 emit PoolCreated( poolCounter,   msg.sender, participants,minimumContribution);
return true;
}
/* join pool, with contribution amount*/
function joinPool(uint poolId,uint amount) external onlyNewPartipant(poolId,msg.sender) returns(bool){
    
    LottoPool memory pool=poolById[poolId];
    require(pool._creator!=address(0),"Pool not exist");
    address participant= msg.sender;
    require(amount==poolById[poolId]._minimumContribution,"the contribution amount should be the exact match");
        require(poolById[poolId]._participantcounter<pool._maxParticipants,"the maximum number of participants reached");
    require(poolById[poolId]._poolId!=0,"Invalid PoolId");
    uint  newcount =poolById[poolId]._participantcounter.add(1);
        poolById[poolId]._participantcounter= newcount;
        poolById[poolId]._participants[newcount]=participant;
        fundsbyPool[poolId]=fundsbyPool[poolId].add(amount);
        _Token.transferFrom(participant,address(this),amount);
        
emit ReceivedSubscription( poolId,  msg.sender, amount, newcount);


return true;
}
function drawWinner(uint poolId) public returns(bool){
    uint winnerNumber= random(0,poolById[poolId]._participantcounter);
    address winnerAddress= getParticipant(poolId,winnerNumber);
    uint reward= fundsbyPool[poolId];
   bool success =  _Token.transfer(winnerAddress,reward);
   delete poolById[poolId];
   pools=removeItem(poolId,pools);
    emit poolDraw(winnerNumber,winnerAddress , reward);
    delete fundsbyPool[poolId];

    return success;
}
 function removeItem(uint item, uint[] memory array) public pure returns(uint[] memory){
       

        for (uint i=0;i<=array.length-1;i++){
            if(array[i]==item){
              delete  array [i];
            }
}
            return array;
        
 }
function getPools() public view returns(uint[] memory){
    return pools;
}

function getPoolbyId(uint poolId) public view returns(uint _poolId,uint _currentParticipants,uint _maxParticipants,uint _contributionAmount,uint timestamp){

return (poolId,poolById[poolId]._participantcounter,poolById[poolId]._maxParticipants,poolById[poolId]._minimumContribution,poolById[poolId]._timestamp);
}
function getParticipant(uint poolId,uint participantId) public view returns(address){
return poolById[poolId]._participants[participantId];
}

    function random(uint low,uint high) public view returns (uint){
        uint retValue=0;
       uint number=uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
       
       uint rand=low+(number%100);
       retValue=rand.mul(high).div(99);
    //   if(rand>(100-high)){
    //       retValue=rand-(100-high);
           
    //   }else{
    // retValue=rand;
     //  }
     retValue=(retValue>0)?retValue:1;
       return retValue;
  }
}