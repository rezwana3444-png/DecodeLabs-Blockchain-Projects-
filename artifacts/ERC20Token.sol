// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {

    // ================================
    // TOKEN IDENTITY
    // ================================
    string public name;          // e.g. "DecodeCoin"
    string public symbol;        // e.g. "DCD"
    uint8 public decimals = 18;  // Standard: 18 decimal places
    uint256 public totalSupply;  // Total tokens ever created

    // ================================
    // THE LEDGER — who owns what
    // ================================
    mapping(address => uint256) private balances;

    // Allowances: owner -> spender -> amount
    mapping(address => mapping(address => uint256)) private allowances;

    // ================================
    // EVENTS — transaction receipts
    // ================================
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ================================
    // CONSTRUCTOR — mint initial supply
    // ================================
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        // Mint all tokens to the deployer
        totalSupply = _initialSupply * (10 ** decimals);
        balances[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // ================================
    // FUNCTION 1: Check balance
    // ================================
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // ================================
    // FUNCTION 2: Transfer tokens
    // ================================
    function transfer(address to, uint256 amount) public returns (bool) {
        // INPUT VALIDATION
        require(to != address(0), "Cannot send to zero address!");
        require(amount > 0, "Amount must be greater than zero!");

        // BALANCE CHECK — can't spend what you don't have!
        require(balances[msg.sender] >= amount, "Insufficient balance!");

        // STATE CHANGE — subtract from sender, add to receiver
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // OUTPUT — emit event as receipt
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // ================================
    // FUNCTION 3: Approve spending
    // ================================
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Invalid spender!");
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // ================================
    // FUNCTION 4: Transfer on behalf
    // ================================
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(from != address(0), "Invalid sender!");
        require(to != address(0), "Invalid receiver!");
        require(balances[from] >= amount, "Insufficient balance!");
        require(allowances[from][msg.sender] >= amount, "Allowance exceeded!");

        // STATE CHANGE
        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // ================================
    // FUNCTION 5: Check allowance
    // ================================
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }
}