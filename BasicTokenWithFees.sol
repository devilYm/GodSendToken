pragma solidity ^0.5.0;
import "./BasicToken.sol";
import "./Ownable";
contract BasicTokenWithFees is BasicToken,Ownable{
    uint256 private FEE_RATE;
    uint256 private _totalDestroyed;
    uint256 private _feeLimit;
    constructor()public Ownable(){
        
    }
    _init(string name,string symbol,uint8 decimals,uint256 totalSupply,uint256 feeRate,uint256 feeLimit) internal {
        FEE_RATE = feeRate;
        _feeLimit = feeLimit;
        super._init(name,symbol,decimals,totalSupply);
    }
    function feeRate() constant returns (uint256){
        return FEE_RATE;
    }
    function feeLimit() constant returns(uint256){
        return _feeLimit;
    }
    function calculateFee(uint256 amount) constant returns(uint256){
        uint256 fee = (amount.mul(FEE_RATE)).div(1000);
        return fee;
    }
    /**
    *see {IERC20-totalDestroyed}
    */
    function totalDestroyed() public view returns(uint256){
        return _totalDestroyed;
    }
    function transfer(address receiver,uint256 amount) public returns (bool){
        uint256 fee = calculateFee(amount);
        uint256 subFeeAmount = amount.sub(fee);
        super.transfer(receiver,subFeeAmount);
        _totalDestroyed.add(fee);
        _totalSupply.sub(fee);
    }
    function transferFrom(address sender,address receiver,uint256 amount) public returns(bool){
        require(amount <= allowance[sender][msg.sender]);
        require(amount > 0,"Transfer amount must be greater than zero");
        require(_balances[sender] >= amount,"Transfer amount exceeds the account's money");
        uint256 fee = calculateFee(amount);
        uint256 subFeeAmount = amount.sub(fee);
        _transfer(sender, receiver, subFeeAmount);
        _totalDestroyed.add(fee);
        _totalSupply.sub(fee);
        decreaseAllowance(sender,amount);
    }
    event ParamChanged(uint256 feeRate,uint256 feeLimit);
    function setParams(uint256 feeRate,uint256 feeLimit) public onlyOwner{
        FEE_RATE = feeRate;
        _feeLimit = feeLimit;
        emit ParamChanged(feeRate,feeLimit);
    }
    function kill() public onlyOwner{
        selfDestruct(msg.sender);
    }
}