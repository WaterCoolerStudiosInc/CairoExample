use snforge_std::DeclareResultTrait;
use core::num::traits::zero::Zero;
use core::serde::Serde;
use core::option::OptionTrait;
use starknet::{ContractAddress, contract_address_const};

use snforge_std::{cheat_caller_address, start_cheat_caller_address_global, CheatSpan};
use snforge_std::{declare, ContractClassTrait};
use example::interface::{
    IToken, ITokenDispatcher, ITokenDispatcherTrait, IVaultDispatcher, IVaultDispatcherTrait
};
use snforge_std::{test_address, start_cheat_caller_address, start_cheat_block_timestamp_global};
use snforge_std::cheatcodes::events::{EventSpyTrait, EventsFilterTrait};


fn deploy_share_token() -> (ITokenDispatcher, ContractAddress) {
    let contract = declare("Token").unwrap().contract_class();
    let owner: ContractAddress = contract_address_const::<'owner'>();

    let mut constructor_calldata = array![owner.into()];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    let dispatcher = ITokenDispatcher { contract_address };

    (dispatcher, contract_address)
}

#[test]
fn test1() {
    let (share_token, token_address) = deploy_share_token();
    let new_owner: ContractAddress = contract_address_const::<'new_owner'>();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    assert!(share_token.owner() == owner);
    start_cheat_caller_address_global(owner);
    let amount: u256 = 100000;
    let result = share_token.mint(new_owner, amount);
    let balance = share_token.balance_of(new_owner);
    assert_eq!(balance, amount);

    let vault_class = declare("Vault").unwrap().contract_class();
    let mut calldata = ArrayTrait::new();
    share_token.serialize(ref calldata);

    let (vault_address, _) = vault_class.deploy(@calldata).unwrap();
    let vault_dispatcher = IVaultDispatcher { contract_address: vault_address };

    let amount: u256 = 100000;
    let result = share_token.mint(new_owner, amount);
    share_token.transfer_ownership(vault_address);
    let share_owner = share_token.owner();
    assert_eq!(share_owner, vault_address);
    // vault address is the owner 
    snforge_std::stop_cheat_caller_address_global();
    vault_dispatcher.deposit(amount: 10000000);
}
#[test]
fn test2() {
    let (share_token, token_address) = deploy_share_token();
    let new_owner: ContractAddress = contract_address_const::<'new_owner'>();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    assert!(share_token.owner() == owner);
    start_cheat_caller_address(token_address, owner);
    let amount: u256 = 100000;
    let result = share_token.mint(new_owner, amount);
    let balance = share_token.balance_of(new_owner);
    assert_eq!(balance, amount);

    let vault_class = declare("Vault").unwrap().contract_class();
    let mut calldata = ArrayTrait::new();
    share_token.serialize(ref calldata);

    start_cheat_caller_address_global(owner);
    let (vault_address, _) = vault_class.deploy(@calldata).unwrap();
    let vault_dispatcher = IVaultDispatcher { contract_address: vault_address };
  
    // share token is still the owner address
    vault_dispatcher.deposit(amount: 10000000);
}

