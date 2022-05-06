// SPDX-License-Identifier: MIT;

pragma solidity ^0.5.16;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */

interface IERC20 {

	// Returns the total token supply.
	function totalSupply() external view returns (uint256);

	// Returns the account balance of another account with address _owner
	function balanceOf(address _owner) external view returns (uint256 balance);

	// Transfers _value amount of tokens to address _to,
	// and must fire the transfer event. 
	// The function should throw if the message callers 
	// amount balance does not have enough tokens to spend
	// Note: Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
	function transfer(address _to, uint256 _value) external returns (bool success);

	// Used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
	// This function should throw unless the _from account has deliberately authorized the sender 
	// of the message via some mechanism.
	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

	// Allows _spender to withdraw from your account
	// multiple times, up to the _value amount.
	function approve(address _spender, uint256 _value) external returns (bool success);

	// Returns the amount which _spender is still allowed to withdraw from _owner.
	function allowance(address _owner, address _spender) external view returns (uint256 remaining);

	// MUST trigger when tokens are transferred, including zero value transfers.
	// A token contract which creates new tokens SHOULD trigger a Transfer event with the _from 
	// address set to 0x0 when tokens are created.

	event Transfer(
		address indexed _from, 
		address indexed _to, 
		uint256 _value
	);

	// MUST trigger on any successful call to approve(address _spender, uint256 _value).
	event Approval(
		address indexed _owner,
		address indexed _spender,
		uint256 _value
	);

}