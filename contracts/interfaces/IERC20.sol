// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;

interface IERC20 {

    // events
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed owner, address indexed spender, uint value);

    // token details
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);

    // address details
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function getOwner() external view returns (address);

    // token actions
    function approve(address spender, uint value) external returns (bool);
    function transfer(address recipient, uint value) external returns (bool);
    function transferFrom(address sender, address recipient, uint value) external returns (bool);
}
