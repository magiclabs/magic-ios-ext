import XCTest
import MagicSDK
@testable import MagicExt_Solana

final class SolanaExtensionTests: XCTestCase {

    private func json(_ value: Encodable) throws -> [String: Any] {
        struct Box: Encodable {
            let value: Encodable
            func encode(to encoder: Encoder) throws { try value.encode(to: encoder) }
        }
        let data = try JSONEncoder().encode(Box(value: value))
        return try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }

    func testConfigurationEncodesRpcUrlAndChainType() throws {
        let configuration = SolanaConfiguration(rpcUrl: "https://api.devnet.solana.com")
        XCTAssertEqual(configuration.name, "solana")
        let encoded = try json(configuration)
        XCTAssertEqual(encoded.count, 2)
        XCTAssertEqual(encoded["rpcUrl"] as? String, "https://api.devnet.solana.com")
        XCTAssertEqual(encoded["chainType"] as? String, "SOLANA")
    }

    func testLegacyTransactionParams() throws {
        let params = try json(SolanaTransactionParams(
            type: .legacy,
            serialized: Data([1, 2, 3]),
            serializeConfig: SolanaSerializeConfig(requireAllSignatures: false)
        ))
        XCTAssertEqual(params["type"] as? String, "legacy")
        XCTAssertEqual((params["serialized"] as? [String: Any])?["data"] as? String, "1,2,3")
        XCTAssertEqual(params["serializeConfig"] as? [String: Bool], ["requireAllSignatures": false])
    }

    func testVersionedTransactionParams() throws {
        let params = try json(SolanaTransactionParams(type: .v0, serialized: Data([4]), serializeConfig: nil))
        XCTAssertEqual(params["type"] as? Int, 0)
        XCTAssertNil(params["serializeConfig"])
    }

    func testSignMessageParams() throws {
        XCTAssertEqual(try json(SolanaSignMessageParams(message: .string("hello")))["message"] as? String, "hello")

        let bytes = try json(SolanaSignMessageParams(message: .bytes(TypedArray(Data([7, 8])))))
        XCTAssertEqual((bytes["message"] as? [String: Any])?["data"] as? String, "7,8")
    }

    func testSignedTransactionDecodesMgboxResponse() throws {
        let response = #"""
        {"rawTransaction":{"constructor":"Buffer","data":"9,8,7","flag":"MAGIC_PAYLOAD_FLAG_TYPED_ARRAY"},
         "signature":[{"signature":null,"publicKey":"11111111111111111111111111111111"}]}
        """#
        let signed = try JSONDecoder().decode(SolanaSignedTransaction.self, from: Data(response.utf8))
        XCTAssertEqual(signed.rawTransaction, Data([9, 8, 7]))
    }

    func testMethodNamesMatchMagicJs() {
        XCTAssertEqual(SolanaMethod.sol_signTransaction.rawValue, "sol_signTransaction")
        XCTAssertEqual(SolanaMethod.sol_signMessage.rawValue, "sol_signMessage")
        XCTAssertEqual(SolanaMethod.sol_partialSignTransaction.rawValue, "sol_partialSignTransaction")
    }

    func testSolanaIsOnlyAvailableWhenConfigured() {
        XCTAssertNotNil(Magic(apiKey: "pk_test", extensions: [SolanaConfiguration(rpcUrl: "https://a")]).solana)
        XCTAssertNil(Magic(apiKey: "pk_test").solana)
    }
}
