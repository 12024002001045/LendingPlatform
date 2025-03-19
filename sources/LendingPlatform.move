module MyModule::LendingPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct LoanPool has store, key {
        total_liquidity: u64,
    }

    /// Function to lend funds into the lending pool.
    public fun lend(lender: &signer, amount: u64) acquires LoanPool {
        let pool = borrow_global_mut<LoanPool>(signer::address_of(lender));
        let deposit = coin::withdraw<AptosCoin>(lender, amount);
        pool.total_liquidity = pool.total_liquidity + amount;
    }

    /// Function to borrow funds from the lending pool.
    public fun borrow(borrower: &signer, amount: u64) acquires LoanPool {
        let pool = borrow_global_mut<LoanPool>(signer::address_of(borrower));
        assert!(pool.total_liquidity >= amount, 1);
        pool.total_liquidity = pool.total_liquidity - amount;
        coin::deposit<AptosCoin>(signer::address_of(borrower), amount);
    }
}
