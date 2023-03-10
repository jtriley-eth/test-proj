use fuels::{prelude::*, tx::ContractId};

// Load abi from json
abigen!(MyContract, "out/debug/test-proj-abi.json");

async fn get_contract_instance() -> (MyContract, ContractId) {
    // Launch a local network and deploy the contract
    let mut wallets = launch_custom_provider_and_get_wallets(
        WalletsConfig::new(
            Some(1),             /* Single wallet */
            Some(1),             /* Single coin (UTXO) */
            Some(1_000_000_000), /* Amount per coin */
        ),
        None,
        None,
    )
    .await;
    let wallet = wallets.pop().unwrap();

    let id = Contract::deploy(
        "./out/debug/test-proj.bin",
        &wallet,
        TxParameters::default(),
        StorageConfiguration::with_storage_path(Some(
            "./out/debug/test-proj-storage_slots.json".to_string(),
        )),
    )
    .await
    .unwrap();

    let instance = MyContract::new(id.clone(), wallet);

    (instance, id.into())
}

#[tokio::test]
async fn passing_tests() {
    let (contract_instance, _id) = get_contract_instance().await;

    let result = contract_instance
        .methods()
        .passes_ok()
        .call()
        .await
        .unwrap();

    assert!(result.value);

    let result = contract_instance
        .methods()
        .passes_err()
        .call()
        .await
        .unwrap();

    assert!(result.value);
}

#[tokio::test]
async fn failing_test() {
    let (contract_instance, _id) = get_contract_instance().await;

    // FAILS HERE
    let result = contract_instance
        .methods()
        .fails()
        .call()
        .await;

    assert!(result.is_err());
}
