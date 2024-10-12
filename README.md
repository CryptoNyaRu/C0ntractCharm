## 单交易部署(推荐)

```solidity
775c300c //deploy()
0000000000000000000000000000000000000000000000000000000000000000 //Salt
365f5f375f5f365f73bebebebebebebebebebebebebebebebebebebebe5af43d5f5f3e5f3d91602a57fd5bf3 //Runtime Bytecode
```

| 版本 |部署 WETH9 消耗 Gas|
|:---: |:---:              |
|Cancun|761365             |
|London|2939148            |

- 单/多交易部署共享 Slot, 因此 London 版本合约执行单交易部署将覆盖 Slot 的内容

## 多交易部署

```solidity
ad77be5e //initBytecode()
365f5f375f5f365f73bebebebebebebebebebebebebebebebebebebebe5af43d5f5f3e5f3d91602a57fd5bf3 //Runtime Bytecode
```

```solidity
2b85ba38 //deploy(bytes32)
0000000000000000000000000000000000000000000000000000000000000000 //Salt
```

- **Cancun 版本合约使用多交易部署将无法享受 TSTORE && TLOAD 的大幅 Gas 优化, 因此不建议使用**

## Loader

```solidity
Bytecode: 0x6000600060006000335afa3d600060003e3d6000f3
    
    How it works:
        Static call msg.sender(C0ntractCharm) to get bytecode:
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            33    => push CALLER to stack
            5a    => push GAS to stack
            fa    => STATICCALL

        Copy returned bytecode to memory:
            3d    => push RETURNDATASIZE to stack
            60 00 => push 0x00 to stack
            60 00 => push 0x00 to stack
            3e    => RETURNDATACOPY

        Return bytecode from memory:
            3d    => push RETURNDATASIZE to stack
            60 00 => push 0x00 to stack
            f3    => RETURN
```

- 推荐配合 [Van1tyETH](https://github.com/CryptoNyaRu/Van1tyETH) 计算 Salt 使用
- 为保证 Salt 通用, 不同版本合约的 Loader 均一致(London)

## 注意事项

- **请务必手动设置 function _owner() 中的地址, 并使用附带的 compiler_config.json 进行编译**
- C0ntractCharm **使用纯 Yul 实现**, 因此在**变更 Solc 或 EVM 版本**时应**充分测试**再部署至生产环境, 以避免预料外的行为
- 请根据 EVM 版本选择 C0ntractCharm, **在 Cancun 版本中使用了 TSTORE && TLOAD 操作码优化 Gas 消耗**
- 用户在写入 Runtime Bytecode 时需注意**欲部署合约的 constructor 将不会被包含或执行**, 若需对新合约进行初始化请自行实现相关逻辑
- 后续若需升级合约, 所创建的合约必须**预留 SELFDESTRUCT 且 EVM 尚未合并 EIP-6780**, 将原合约 SELFDESTRUCT 后使用相同 Salt 重新部署即可

## 原理

- 将 Runtime Bytecode 写入 (Transient)Storage
- 将 Loader Bytecode 作为参数传入 CREATE2 并执行, 执行过程中将获取 C0ntractCharm 中先前写入的 Runtime Bytecode 并返回以创建合约
- 由于 CREATE2 固定使用 Loader Bytecode, 因此即使 Runtime Bytecode 不同, 也无需变更计算 Salt 的参数

## 相关链接

- https://docs.soliditylang.org/en/v0.8.28/yul.html
- https://etherscan.io/address/0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2#code
- https://ethereum.stackexchange.com/questions/76334/what-is-the-difference-between-bytecode-init-code-deployed-bytecode-creation
- https://ctf-wiki.org/blockchain/ethereum/attacks/create2/
- https://github.com/CryptoNyaRu/Van1tyETH
- https://eips.ethereum.org/EIPS/eip-6780
