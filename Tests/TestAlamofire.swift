import Alamofire
import CPKAlamofire
import OHHTTPStubs
import PromiseKit
import CancelForPromiseKit
import XCTest

class AlamofireTests: XCTestCase {
    func test() {
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        firstly {
            Alamofire.request("http://example.com", method: .get).responseJSONCC()
        }.done { _ in
            XCTFail("failed to cancel request")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("Error: \(error)")
        }.cancel()

        waitForExpectations(timeout: 1)
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
    }
    
    #if swift(>=3.2)
    private struct Fixture: Decodable {
        let key1: String
        let key2: [String]
    }
    
    func testDecodable1() {
        
        func getFixture() -> CancellablePromise<Fixture> {
            return Alamofire.request("http://example.com", method: .get).responseDecodableCC(queue: nil)
        }
        
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        getFixture().done { fixture in
            XCTAssert(fixture.key1 == "value1", "Value1 found")
            XCTFail("failed to cancel request")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("Error: \(error)")
        }.cancel()
        
        waitForExpectations(timeout: 1)
    }
    
    func testDecodable2() {
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        firstly {
            Alamofire.request("http://example.com", method: .get).responseDecodableCC(Fixture.self)
        }.done { fixture in
            XCTAssert(fixture.key1 == "value1", "Value1 found")
            XCTFail("failed to cancel request")
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail("Error: \(error)")
        }.cancel()
        
        waitForExpectations(timeout: 1)
        
    }
    #endif
}
