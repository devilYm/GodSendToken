pragma solidity ^0.5.0;
import "./IERC20.sol"
import "./SafeMath.sol"
contract BasicToken is IERC20{
    using SafeMath for uint256;
    string private _name;
    string private _symbol;
    unit8 private _decimals;
    uint256 private _totalSupply;

    
    mapping(address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    _init(string name,string symbol,uint8 decimals,uint256 totalSupply)internal{
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply;
        _balances[msg.sender] = totalSupply;
    }

    function name() public view returns (string) {
        return _name;
    }

    function symbol() public view returns (string) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    
   
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address receiver, uint256 amount) public returns (bool) {
        _transfer(msg.sender, receiver, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address receiver, uint256 amount) public returns (bool) {
        require(amount <= allowance[sender][msg.sender]);
        require(amount > 0,"Transfer amount must be greater than zero");
        _transfer(sender, receiver, amount);
        decreaseAllowance(sender，amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(addedValue > 0);
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(subtractedValue > 0);
        unit oldValue = _allowances[msg.sender][spender];
        if(oldValue > subtractedValue){
            _approve(msg.sender, spender, oldValue.sub(subtractedValue));
        }else{
             _approve(msg.sender, spender, 0);
        }
        return true;
    }

    function _transfer(address sender, address receiver, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(receiver != address(0), "ERC20: transfer to the zero address");
        require(amount > 0,"Transfer amount must be greater than zero");
        require(_balances[sender] >= amount,"Transfer amount exceeds the account's money");
        require(_balances[receiver] + amount >= _balances[receiver]);
        _balances[sender] = _balances[sender].sub(amount);
        _balances[receiver] = _balances[receiver].add(amount);
        emit Transfer(sender, receiver, amount);
    }
    
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }
}