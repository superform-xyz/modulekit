// SPDX-License-Identifier: MIT
pragma solidity >=0.8.23 <0.9.0;

// Utils
import { etch } from "../../test/utils/Vm.sol";

// Interfaces
import { IEntryPoint } from "../../external/ERC4337.sol";

// External Dependencies
import { SenderCreator } from "@ERC4337/account-abstraction/contracts/core/EntryPoint.sol";
import { ISenderCreator } from
    "@ERC4337/account-abstraction/contracts/interfaces/ISenderCreator.sol";
import { EntryPointSimulations } from
    "@ERC4337/account-abstraction/contracts/core/EntryPointSimulations.sol";

contract EntryPointSimulationsPatch is EntryPointSimulations {
    address public _entrypointAddr = address(this);
    SenderCreator private _senderCreator;

    function init(address entrypointAddr) public {
        _entrypointAddr = entrypointAddr;
        initSenderCreator();
    }

    function initSenderCreator() internal override {
        // Create a new SenderCreator that recognizes this contract as the EntryPoint
        _senderCreator = new SenderCreator();

        _initDomainSeparator();
    }

    function senderCreator() public view virtual override returns (ISenderCreator) {
        return _senderCreator;
    }
}

/// @dev Preset entrypoint address
address constant ENTRYPOINT_ADDR = 0x4337084D9E255Ff0702461CF8895CE9E3b5Ff108;

function etchEntrypoint() returns (IEntryPoint) {
    address payable entryPoint = payable(address(new EntryPointSimulationsPatch()));
    etch(ENTRYPOINT_ADDR, entryPoint.code);
    EntryPointSimulationsPatch(payable(ENTRYPOINT_ADDR)).init(entryPoint);

    return IEntryPoint(ENTRYPOINT_ADDR);
}
