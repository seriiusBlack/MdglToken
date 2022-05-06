// SPDX-License-Identifier: MIT;

// EIP-20: 0.4.17 or Above
pragma solidity 0.8.11;

import "../lib/SafeMath.sol";
import "../interfaces/IERC20.sol";

contract MdglToken is IERC20 {

	using SafeMath for uint256;
	
	string public _name = "Mdgl Token";

	string public _symbol = "MDGL";

	uint256 public _decimals = 18;

	uint256 public _totalSupply;

	bool public _stopped;

	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowed;

	event Paid(address indexed _from, uint _value, uint _total);

	event Burnt(address indexed _owner, uint256 _value);

	event SelfDestructed(address indexed _owner);

	constructor() {
		address public _admin = address(0xB84ea7B5e844598f23767Aa5d089107bf27830a0);
		_totalSupply = 1000000000000000000000;
		_balances[_admin] = _totalSupply;
		_stopped = false;
	}

	modifier isAdmin() {
    		require(msg.sender == _admin);
    		_;
	}

	function name() public view returns (string memory) {
		return _name;
	}

	function symbol() public view returns (string memory) {
		return _symbol;
    	}

    	function decimals() public view returns (uint256) {
		return _decimals;
   	}

    	function totalSupply() public override view returns (uint256) {
		return _totalSupply;
   	}

	function balanceOf(address _owner) public override view returns (uint256) {
		return _balances[_owner];
    	}

	function transfer(address to, uint256 value) public override returns (bool) {
		require(value <= _balances[msg.sender]);
		require(to != address(0x0));
		require(to != address(this));

		_balances[msg.sender] = _balances[msg.sender].sub(value);
		_balances[to] = _balances[to].add(value);
		emit Transfer(msg.sender, to, value);
		return true;
   	 }

	function transferFrom(
		address from, 
		address to, 
		uint256 value
   	)
		public
		override
		returns (bool success)
    	{
		require(value <= _balances[from]);
		require(value <= _allowed[from][msg.sender]);
		require(to != address(0x0));
		require(to != address(this));

		_balances[from] = _balances[from].sub(value);
		_balances[to] = _balances[to].add(value);
		_allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
		emit Transfer(from, to, value);
		return success;
  	}

	function approve(address spender, uint256 value) public override returns (bool response) {
		require(spender != address(0));

		_allowed[msg.sender][spender] = value;
		emit Approval(msg.sender, spender, value);
		return response;
   	}

	function allowance(
		address _owner,
		address spender
    	)
		public
		override
		view
		returns (uint256)
    	{
		return _allowed[_owner][spender];
    	}
	
	function _burn(uint256 value) public isAdmin() returns (bool success) {

		require(value <= _balances[msg.sender]);

		_balances[msg.sender] = _balances[msg.sender].sub(value);

		_balances[address(0)] = _balances[address(0)].add(value);

		_totalSupply = _totalSupply.sub(value);

		emit Burnt(msg.sender, value);

		return success;
	}

	function selfDestruct(address _owner) public isAdmin() {
		this.setState(3);
		selfdestruct(payable(_owner));
		stopped = true;
		emit SelfDestructed(_owner);
	}
}
