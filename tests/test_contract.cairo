use snforge_std::DeclareResultTrait;
use core::num::traits::zero::Zero;
use core::serde::Serde;
use core::option::OptionTrait;
use starknet::{ContractAddress, contract_address_const};

use snforge_std::{cheat_caller_address, CheatSpan};
use snforge_std::{declare, ContractClassTrait};
use example::token::interface::{
    IToken, ITokenDispatcher, ITokenDispatcherTrait
};
use snforge_std::{test_address, start_cheat_caller_address, start_cheat_block_timestamp_global};
use snforge_std::cheatcodes::events::{EventSpyTrait, EventsFilterTrait};


fn deploy_share_token() -> (IShareTokenDispatcher, ContractAddress) {
    let contract = declare("ShareToken").unwrap().contract_class();
    let owner: ContractAddress = contract_address_const::<'owner'>();

    let mut constructor_calldata = array![owner.into()];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    let dispatcher = IShareTokenDispatcher { contract_address };

    (dispatcher, contract_address)
}

#[test]
fn test_deploy() {
    let (share_token, token_address) = deploy_share_token();
    let new_owner: ContractAddress = contract_address_const::<'new_owner'>();
    let owner: ContractAddress = contract_address_const::<'owner'>();
    assert!(share_token.owner() == owner);

    start_cheat_caller_address(token_address, owner);
    let amount: u256 = 100000;
    let result = share_token.mint(new_owner, amount);
 

}
