// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

contract ERC20 is IERC20 { 

    address public owner;
    string public name = "RugCoin";
    string public symbol = "RUG";
    uint8 public decimals = 18;
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address owner => mapping(address spender => uint256)) private _allowances;

    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** decimals;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function _transfer(address from, address to, uint256 value) private {
        if (from == address(0)) {
            revert("ERC20: transfer from the zero address");
        }
        if (to == address(0)) {
            revert("ERC20: transfer to the zero address");
        }
        if (_balances[from] < value) {
            revert("ERC20: transfer amount exceeds balance");
        }

        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from, to, value);
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public override returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        if (_allowances[from][msg.sender] < value) {
            revert("ERC20: transfer amount exceeds allowance");
        }

        _allowances[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

}