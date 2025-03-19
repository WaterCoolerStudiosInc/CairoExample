#[starknet::contract]
pub mod Vault {
    use crate::interface::{ITokenDispatcher, ITokenDispatcherTrait,IVault};
    use starknet::storage::{
        Map, Vec, StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, VecTrait,
        MutableVecTrait
    };
    use starknet::{
        ContractAddress, ClassHash, get_caller_address, get_contract_address, get_block_timestamp
    };
    #[storage]
    struct Storage {
        token: ITokenDispatcher,
    }
    #[constructor]
    fn constructor(ref self: ContractState, _token: ContractAddress) {
        self.token.write(ITokenDispatcher { contract_address: _token });
    }
    #[abi(embed_v0)]
    impl VaultImpl of IVault<ContractState> {
        fn deposit(ref self: ContractState, amount: u256) {
            let curr_time = get_block_timestamp();
            //self.update_fees(curr_time);
            let caller = get_caller_address();
            let this = get_contract_address();
            self.token.read().mint(caller, amount);
        }
    }
}
