// SPDX-License-Identifier: MIT

pragma solidity >=0.5.16;

import './interfaces/ISoulSwapFactory.sol';
import './SoulSwapPair.sol';

contract SoulSwapFactory is ISoulSwapFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(SoulSwapPair).creationCode));

    address public feeTo;
    address public feeToSetter = msg.sender;
    address public migrator;
    uint256 public totalPairs = 0;
    address[] public allPairs;

    mapping(address => mapping(address => address)) public getPair;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    event SetFeeTo(address indexed user, address indexed feeTo);
    event SetMigrator(address indexed user, address indexed migrator);
    event FeeToSetter(address indexed user, address indexed feeToSetter);

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'SoulSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'SoulSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'SoulSwap: PAIR_EXISTS'); // single check is sufficient

        bytes memory bytecode = type(SoulSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        
        assembly { pair := create2(0, add(bytecode, 32), mload(bytecode), salt) }
        SoulSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        totalPairs++;
        
        emit PairCreated(token0, token1, pair, totalPairs);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'SoulSwap: FORBIDDEN');
        feeTo = _feeTo;
        
        emit SetFeeTo(msg.sender, feeTo);
    }

    function setMigrator(address _migrator) external {
        require(msg.sender == feeToSetter, 'SoulSwap: FORBIDDEN');
        migrator = _migrator;
        
        emit SetMigrator(msg.sender, migrator);
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'SoulSwap: FORBIDDEN');
        feeToSetter = _feeToSetter;
        
        emit FeeToSetter(msg.sender, feeToSetter);
    }

}
