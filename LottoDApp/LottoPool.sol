
pragma solidity ^0.5.16;
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
contract lottoPool {
    struct lottoPool{
        address _creator;
        uint _maxParticipants;
        uint _currentParticipants;
    }
    constructor()public{
    }
    

    function random(uint low,uint high) public view returns (uint){
        uint retValue=0;
       uint number=uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
       uint rand=low+(number%100);
       if(rand>(100-high)){
           retValue=rand-(100-high);
           
       }else{
    retValue=rand;
       }
       return retValue;
  }
}