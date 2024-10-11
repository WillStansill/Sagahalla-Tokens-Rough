// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {CertificateController} from "./CertificateController.sol";

contract ManaToken is IERC20, Ownable {
    CertificateController public certificateController;

    // ERC-20 states
    string private _name = "ManaToken";
    string private _symbol = "MANA";
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // ERC-1400 states (partition-based tokens)
    mapping(bytes32 => mapping(address => uint256))
        private _balancesByPartition;
    mapping(bytes32 => bool) private _partitionExists;
    bytes32[] public partitions;
    mapping(address => bool) public isCollateralized; // Tracks if the account is in ERC-1400 mode

    constructor(address _certificateController) Ownable() {
        certificateController = CertificateController(_certificateController);
    }

    // Token Info (ERC-20)
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (isCollateralized[account]) {
            return balanceOfByPartition("default", account);
        }
        return _balances[account];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(recipient != address(0), "Transfer to zero address");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        require(
            _allowances[sender][msg.sender] >= amount,
            "Transfer amount exceeds allowance"
        );
        _allowances[sender][msg.sender] -= amount;
        _transfer(sender, recipient, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    // Internal ERC-20 transfer
    function _transfer(address from, address to, uint256 amount) internal {
        if (isCollateralized[from] || isCollateralized[to]) {
            _transferByPartition("default", from, to, amount, "");
        } else {
            require(_balances[from] >= amount, "Insufficient balance");
            _balances[from] -= amount;
            _balances[to] += amount;
            emit Transfer(from, to, amount);
        }
    }

    // Mint ERC-20 tokens
    function mint(address account, uint256 amount) external onlyOwner {
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    // Burn ERC-20 tokens
    function burn(address account, uint256 amount) external onlyOwner {
        require(_balances[account] >= amount, "Insufficient balance");
        _balances[account] -= amount;
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    // Collateralize and switch to ERC-1400 mode
    function collateralize(
        address account,
        uint256 amount,
        bytes calldata data
    ) external onlyOwner {
        require(!isCollateralized[account], "Already collateralized");
        require(
            certificateController.isValidCertificate(data),
            "Invalid certificate"
        );
        burn(account, amount);
        _mintByPartition("default", account, amount * 100000, data);
        isCollateralized[account] = true;
    }

    // ERC-1400 Functions (Partition-based tokens)
    function balanceOfByPartition(
        bytes32 partition,
        address account
    ) public view returns (uint256) {
        return _balancesByPartition[partition][account];
    }

    function _mintByPartition(
        bytes32 partition,
        address account,
        uint256 amount,
        bytes calldata data
    ) internal {
        require(
            certificateController.isValidCertificate(data),
            "Invalid certificate"
        );
        _balancesByPartition[partition][account] += amount;

        // Track partition existence for efficient lookups
        if (!_partitionExists[partition]) {
            _partitionExists[partition] = true;
            partitions.push(partition);
        }

        emit IssuedByPartition(
            partition,
            msg.sender,
            account,
            amount,
            data,
            ""
        );
    }

    function transferByPartition(
        bytes32 partition,
        address recipient,
        uint256 value,
        bytes calldata data
    ) external returns (bytes32) {
        require(
            certificateController.isValidCertificate(data),
            "Invalid certificate"
        );
        _transferByPartition(partition, msg.sender, recipient, value, data);
        return partition;
    }

    function _transferByPartition(
        bytes32 partition,
        address from,
        address to,
        uint256 value,
        bytes calldata data
    ) internal {
        require(
            _balancesByPartition[partition][from] >= value,
            "Insufficient balance"
        );
        _balancesByPartition[partition][from] -= value;
        _balancesByPartition[partition][to] += value;
        emit TransferByPartition(partition, from, from, to, value, data, "");
    }

    event IssuedByPartition(
        bytes32 indexed partition,
        address indexed operator,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );
    event TransferByPartition(
        bytes32 indexed partition,
        address operator,
        address indexed from,
        address indexed to,
        uint256 value,
        bytes data,
        bytes operatorData
    );
}
