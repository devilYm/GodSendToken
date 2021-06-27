pragma solidity ^0.5.0;
import "./BasicTokenWithFees.sol"

contract GodSendToken is BasicTokenWithFees{
    construct() public {
        super._init("GodSendTOKEN","GST",16,1*(10**16)*(10**16),10,1*(10**14)*(10**16));
    }
}