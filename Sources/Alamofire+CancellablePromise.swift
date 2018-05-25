import Alamofire
import PromiseKit
#if !CPKCocoaPods
@testable import CancelForPromiseKit
#endif

extension Request: CancellableTask {
    public var isCancelled: Bool {
        return task?.state == .canceling
    }
}

extension Alamofire.DataRequest {
    func wrap<T>(_ promise: Promise<T>) -> CancellablePromise<T> {
        return CancellablePromise(task: self) { seal in
            promise.done {
                seal.fulfill($0)
            }.catch {
                seal.reject($0)
            }
        }
    }
    
   func wrapCC<T>(_ promise: Promise<T>, cancel: CancelContext?) -> Promise<T> {
        return Promise(cancel: cancel ?? CancelContext(), task: self) { seal in
            promise.done {
                seal.fulfill($0)
            }.catch {
                seal.reject($0)
            }
        }
    }

    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil) -> CancellablePromise<(URLRequest, HTTPURLResponse, Data)> {
        return wrap(self.response(.promise, queue: queue))
    }
    
    public func responseCN(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(URLRequest, HTTPURLResponse, Data)> {
        return wrapCC(self.response(.promise, queue: queue), cancel: cancel)
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(data: Data, response: PMKAlamofireDataResponse)> {
        return wrapCC(self.responseData(queue: queue), cancel: cancel)
    }
    
    public func responseStringCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(string: String, response: PMKAlamofireDataResponse)> {
        return wrapCC(self.responseString(queue: queue), cancel: cancel)
    }
    
    public func responseJSONCC(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, cancel: CancelContext? = nil) -> Promise<(json: Any, response: PMKAlamofireDataResponse)> {
        return wrapCC(self.responseJSON(queue: queue, options: options), cancel: cancel)
    }
    
    public func responsePropertyListCC(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(), cancel: CancelContext? = nil) -> Promise<(plist: Any, response: PMKAlamofireDataResponse)> {
        return wrapCC(self.responsePropertyList(queue: queue, options: options), cancel: cancel)
    }
    
    #if swift(>=3.2)
    public func responseDecodableCC<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelContext? = nil) -> Promise<T> {
        return wrapCC(self.responseDecodable(queue: queue, decoder: decoder), cancel: cancel)
    }
    
    public func responseDecodableCC<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelContext? = nil) -> Promise<T> {
        return wrapCC(self.responseDecodable(type, queue: queue, decoder: decoder), cancel: cancel)
    }
    #endif
}

extension Alamofire.DownloadRequest {
    func wrapCC<T>(_ promise: Promise<T>, cancel: CancelContext?) -> Promise<T> {
        return Promise(cancel: cancel ?? CancelContext(), task: self) {seal in
            promise.done {
                seal.fulfill($0)
            }.catch {
                seal.reject($0)
            }
        }
    }

    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<DefaultDownloadResponse> {
        return wrapCC(self.response(.promise, queue: queue), cancel: cancel)
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<DownloadResponse<Data>> {
        return wrapCC(self.responseData(queue: queue), cancel: cancel)
    }
}
