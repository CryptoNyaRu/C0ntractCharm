/*
    Version: 2.0.0
    Compatibility:
        Solc: 0.8.28
        EVM: >=Cancun
*/
object "C0ntractCharm" {
    code {
        datacopy(0, dataoffset("C0ntractCharm_deployed"), datasize("C0ntractCharm_deployed"))
        return(0, datasize("C0ntractCharm_deployed"))
    }
    object "C0ntractCharm_deployed" {
        code {
            // Constant
            function _owner() -> _ { _ := xBEbeBeBEbeBebeBeBEBEbebEBeBeBebeBeBebebe }
            function _loader() -> _ { _ := 0x6000600060006000335afa3d600060003e3d6000f30000000000000000000000 }

            // Storage Layout
            function _bytecodeSlot() -> _ { _ := 0x00 }
            function _bytecodeExpandSlot() -> _ { _ := 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563 }
            function _usingTransientSlot() -> _ { _ := 0x01 }

            {
                if callvalue() {
                    revert(0, 0)
                }
            }

            {
                if iszero(calldatasize()) { //loader calls
                    switch tload(_usingTransientSlot())
                    case 0 {
                        let slotContent := sload(_bytecodeSlot())
                        switch mod(slotContent, 0x02)
                        case 1 { //length >= 32 bytes
                            let length := div(sub(slotContent, 1), 2)
                            let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
        
                            for { let i } lt(i, iter) { i := add(i, 0x01) } {
                                mstore(add(0x00, mul(i, 0x20)), sload(add(_bytecodeExpandSlot(), i)))
                            }
                            return(0x00, length)
                        }
                        default { //length <= 31 bytes
                            mstore(0x00, shl(8, shr(8, slotContent))) //value
                            return(0x00, div(shr(248, shl(248, slotContent)), 2)) //length = slotContentLastByte / 2
                        }
                    }
                    default { //using transient
                        let slotContent := tload(_bytecodeSlot())
                        switch mod(slotContent, 0x02)
                        case 1 { //length >= 32 bytes
                            let length := div(sub(slotContent, 1), 2)
                            let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
        
                            for { let i } lt(i, iter) { i := add(i, 0x01) } {
                                mstore(add(0x00, mul(i, 0x20)), tload(add(_bytecodeExpandSlot(), i)))
                            }
                            return(0x00, length)
                        }
                        default { //length <= 31 bytes
                            mstore(0x00, shl(8, shr(8, slotContent))) //value
                            return(0x00, div(shr(248, shl(248, slotContent)), 2)) //length = slotContentLastByte / 2
                        }
                    }
                }
            }

            {
                if sub(caller(), _owner()) {
                    mstore(0x00, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                    mstore(0x04, 0x0000000000000000000000000000000000000000000000000000000000000020)
                    mstore(0x24, 0x0000000000000000000000000000000000000000000000000000000000000011)
                    mstore(0x44, 0x5045524d495353494f4e5f44454e494544000000000000000000000000000000) //PERMISSION_DENIED
                    revert(0x00, 0x64)
                }
            }

            switch shr(224, calldataload(0x00))
            case 0x775c300c { //deploy()
                {
                    let length := sub(calldatasize(), 0x24)
                    switch gt(length, 0x1f)
                    case 1 { //length >= 32 bytes
                        tstore(_bytecodeSlot(), add(mul(length, 2), 1)) //write length
                        let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
                        for { let i } lt(i, iter) { i := add(i, 0x01) } {
                            tstore(add(_bytecodeExpandSlot(), i), calldataload(add(0x24, mul(0x20, i))))
                        }
                    }
                    default { //length <= 31 bytes
                        mstore(0x00, calldataload(0x24))
                        mstore8(0x1f, mul(length, 2))
                        tstore(_bytecodeSlot(), mload(0x00))
                    }
                    tstore(_usingTransientSlot(), 1)
                }

                {
                    mstore(0x00, _loader())
                    let skipPOP := create2(
                        0x00,
                        0x00,
                        0x15, //21 bytes
                        calldataload(0x04) //salt
                    )
                    stop()
                }
            }
            case 0xad77be5e { //initBytecode()
                let length := sub(calldatasize(), 0x04)
                switch gt(length, 0x1f)
                case 1 { //length >= 32 bytes
                    sstore(_bytecodeSlot(), add(mul(length, 2), 1)) //write length
                    let iter := add(div(length, 0x20), gt(mod(length, 0x20), 0))
                    for { let i } lt(i, iter) { i := add(i, 0x01) } {
                        sstore(add(_bytecodeExpandSlot(), i), calldataload(add(0x04, mul(0x20, i))))
                    }
                }
                default { //length <= 31 bytes
                    mstore(0x00, calldataload(0x04))
                    mstore8(0x1f, mul(length, 2))
                    sstore(_bytecodeSlot(), mload(0x00))
                }
				stop()
            }
            case 0x2b85ba38 { //deploy(bytes32)
                mstore(0x00, _loader())
                let skipPOP := create2(
                    0x00,
                    0x00,
                    0x15, //21 bytes
                    calldataload(0x04) //salt
                )
				stop()
            }
            default {
                revert(0, 0)
            }
        }
    }
}
