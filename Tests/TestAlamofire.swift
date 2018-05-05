import Alamofire
import CPKAlamofire
import OHHTTPStubs
import PromiseKit
import CancellablePromiseKit
import XCTest

class AlamofireTests: XCTestCase {
    func test() {
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        let context = CancelContext.makeContext()
        let rq = Alamofire.request("http://example.com", method: .get).responseJSON(cancel: context).done { rsp in
            XCTFail()
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail()
        }
        context.cancelAll()
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
        
        func getFixture(context: CancelMode) -> Promise<Fixture> {
            return Alamofire.request("http://example.com", method: .get).responseDecodable(queue: nil, cancel: context)
        }
        
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        let context = CancelContext.makeContext()
        getFixture(context: context).done { fixture in
            XCTAssert(fixture.key1 == "value1", "Value1 found")
            XCTFail()
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail()
        }
        context.cancelAll()
        waitForExpectations(timeout: 1)
        
    }
    
    func testDecodable2() {
        let json: NSDictionary = ["key1": "value1", "key2": ["value2A", "value2B"]]
        
        OHHTTPStubs.stubRequests(passingTest: { $0.url!.host == "example.com" }) { _ in
            return OHHTTPStubsResponse(jsonObject: json, statusCode: 200, headers: nil)
        }
        
        let ex = expectation(description: "")
        
        let context = CancelContext.makeContext()
        firstly {
            Alamofire.request("http://example.com", method: .get).responseDecodable(Fixture.self, cancel: context)
        }.done { fixture in
            XCTAssert(fixture.key1 == "value1", "Value1 found")
            XCTFail()
        }.catch(policy: .allErrors) { error in
            error.isCancelled ? ex.fulfill() : XCTFail()
        }
        context.cancelAll()
        
        waitForExpectations(timeout: 1)
        
    }
    #endif
}
