import Alamofire
import PromiseKit
#if !CPKCocoaPods
import CancelForPromiseKit
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
    
    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil) -> CancellablePromise<(URLRequest, HTTPURLResponse, Data)> {
        return wrap(self.response(.promise, queue: queue))
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil) -> CancellablePromise<(data: Data, response: PMKAlamofireDataResponse)> {
        return wrap(self.responseData(queue: queue))
    }
    
    public func responseStringCC(queue: DispatchQueue? = nil) -> CancellablePromise<(string: String, response: PMKAlamofireDataResponse)> {
        return wrap(self.responseString(queue: queue))
    }
    
    public func responseJSONCC(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) -> CancellablePromise<(json: Any, response: PMKAlamofireDataResponse)> {
        return wrap(self.responseJSON(queue: queue, options: options))
    }
    
    public func responsePropertyListCC(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> CancellablePromise<(plist: Any, response: PMKAlamofireDataResponse)> {
        return wrap(self.responsePropertyList(queue: queue, options: options))
    }
    
    #if swift(>=3.2)
    public func responseDecodableCC<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder()) -> CancellablePromise<T> {
        return wrap(self.responseDecodable(queue: queue, decoder: decoder))
    }
    
    public func responseDecodableCC<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder()) -> CancellablePromise<T> {
        return wrap(self.responseDecodable(type, queue: queue, decoder: decoder))
    }
    #endif
}

extension Alamofire.DownloadRequest {
    func wrap<T>(_ promise: Promise<T>) -> CancellablePromise<T> {
        return CancellablePromise(task: self) { seal in
            promise.done {
                seal.fulfill($0)
            }.catch {
                seal.reject($0)
            }
        }
    }

    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil) -> CancellablePromise<DefaultDownloadResponse> {
        return wrap(self.response(.promise, queue: queue))
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil) -> CancellablePromise<DownloadResponse<Data>> {
        return wrap(self.responseData(queue: queue))
    }
}
