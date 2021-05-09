
pragma solidity ^0.5.16;
/*
Lotto pool interface
*/
interface  ILotto{

function createPool(uint participants,uint minimumContribution)public returns(bool);
function joinPool(uint poolId,uint amount) public returns(bool);
function pickWinnerFromPool(uint id) public returns(address _winner);

function PoolInfobyId(uint PoolId) public view returns(uint _poolId,uint _totalparticipants, uint _maxParticipants,uint _minimumContribution,uint _creationTime);
event PoolCreated(uint indexed poolId, address  creater, uint participants,uint contribution);
event poolDraw(uint indexed PoolId, address winner, uint winningAmount);
event ReceicedSubscription(uint poolId, address subscriber,uint amount,uint indexed participant Id);
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
contract lottoPool is ILotto{
    struct lottoPool{
        sddress _creator;
        uint _maxParticipants;
        uint_
    }
}