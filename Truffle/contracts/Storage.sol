pragma solidity >=0.5.0 <0.9.0;

contract Storage {
  uint myVariable;

  function set(uint x) public {
    myVariable = x;
  }

  function get() view public returns (uint) {
    return myVariable;
  }
}
