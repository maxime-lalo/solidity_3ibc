// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.5.16;
contract Casino {
    
    uint bankAccount = 1000;
    uint[] red = [1,3,5,7,9,12,14,16,18,19,21,23,27,30,32,34,36];
    function roll(string memory numberSelected,uint stake) public returns (uint randomNbr){
        uint256 rdm = random();
        uint256 nbr = rdm % 36;
        uint multiplier = getMultiplier(nbr,numberSelected);
        if(multiplier == 0){
            bankAccount += stake;
        }else{
            bankAccount -= (stake*multiplier);
        }
        return nbr;
    }
    
    function random() public view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, now, bankAccount))
            );
    }
    
    function getMultiplier(uint nbr, string memory numberSelected) public view returns (uint multiplier){
        if (nbr == 0) {
            return 0;
        }else{
            if( keccak256(bytes(numberSelected)) == keccak256(bytes("1-18")) && (nbr >= 1 && nbr <= 18) ){
                return 2;
            }else if ( keccak256(bytes(numberSelected)) == keccak256(bytes("19-36")) && (nbr >= 19 && nbr <= 36)  ){
                return 2;
            }else if( keccak256(bytes(numberSelected)) == keccak256(bytes("Rouge")) && (nbr >= 1 && nbr <= 18)  ){
                for(uint i = 0; i < 16; i++){
                    if (red[i] == nbr) {
                        return 2;
                    }
                }
            }else if( keccak256(bytes(numberSelected)) == keccak256(bytes("Noir")) ){
                for(uint i = 0; i < 16; i++){
                    if (red[i] == nbr) {
                        return 0;
                    }
                }

                return 2;
            }else if( keccak256(bytes(numberSelected)) == keccak256(bytes("Pair")) && (nbr % 2 == 0) ){
                return 2;
            }else if( keccak256(bytes(numberSelected)) == keccak256(bytes("Impair")) && (nbr % 2 == 1)  ){
                return 2;
            }else{
                return 0;
            }
        }
    }
}