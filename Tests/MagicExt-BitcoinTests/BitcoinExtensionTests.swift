import XCTest
import MagicSDK
@testable import MagicExt_Bitcoin

final class BitcoinExtensionTests: XCTestCase {

    private func json(_ value: Encodable) throws -> [String: Any] {
        struct Box: Encodable {
            let value: Encodable
            func encode(to encoder: Encoder) throws { try value.encode(to: encoder) }
        }
        let data = try JSONEncoder().encode(Box(value: value))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    func testConfigurationEncodesNetworkUnderOptions() throws {
        let configuration = BitcoinConfiguration(rpcUrl: "https://btc.example.com", network: "testnet")
        XCTAssertEqual(configuration.name, "bitcoin")
        let encoded = try json(configuration)
        XCTAssertEqual(encoded.count, 3)
        XCTAssertEqual(encoded["rpcUrl"] as? String, "https://btc.example.com")
        XCTAssertEqual(encoded["chainType"] as? String, "BITCOIN")
        XCTAssertEqual(encoded["options"] as? [String: String], ["network": "testnet"])
    }

    func testTransactionParams() throws {
        let params = try json(BitcoinTransactionParams(
            inputs: [BitcoinTransactionInput(txid: "abc", txNum: 1, value: 0.0001)],
            outputs: [BitcoinTransactionOutput(address: "tb1q", value: 0.00005)]
        ))
        let input = try XCTUnwrap((params["inputs"] as? [[String: Any]])?.first)
        XCTAssertEqual(input["txid"] as? String, "abc")
        XCTAssertEqual(input["tx_num"] as? Int, 1)
        XCTAssertEqual(input["value"] as? Double, 0.0001)
        XCTAssertNil(input["address"])
        XCTAssertNil(input["txNum"])

        let output = try XCTUnwrap((params["outputs"] as? [[String: Any]])?.first)
        XCTAssertEqual(output["address"] as? String, "tb1q")
        XCTAssertEqual(output["value"] as? Double, 0.00005)
    }

    func testMethodNameMatchesMagicJs() {
        XCTAssertEqual(BitcoinMethod.btc_signTransaction.rawValue, "btc_signTransaction")
    }

    func testBitcoinIsOnlyAvailableWhenConfigured() {
        XCTAssertNotNil(Magic(apiKey: "pk_test", extensions: [BitcoinConfiguration(rpcUrl: "https://a", network: "testnet")]).bitcoin)
        XCTAssertNil(Magic(apiKey: "pk_test").bitcoin)
    }
}
