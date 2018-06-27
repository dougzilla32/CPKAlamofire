import Alamofire
import PromiseKit

#if Carthage
import PMKAlamofire
#else
#if swift(>=4.1)
#if canImport(PMKAlamofire)
import PMKAlamofire
#endif
#endif
#endif

#if !CPKCocoaPods
import CancelForPromiseKit
#endif

extension Request: CancellableTask {
    public var isCancelled: Bool {
        return task?.state == .canceling
    }
}

extension Alamofire.DataRequest {
    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil) -> CancellablePromise<(URLRequest, HTTPURLResponse, Data)> {
        return CancellablePromise(task: self, self.response(.promise, queue: queue))
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil) -> CancellablePromise<(data: Data, response: PMKAlamofireDataResponse)> {
        return CancellablePromise(task: self, self.responseData(queue: queue))
    }
    
    public func responseStringCC(queue: DispatchQueue? = nil) -> CancellablePromise<(string: String, response: PMKAlamofireDataResponse)> {
        return CancellablePromise(task: self, self.responseString(queue: queue))
    }
    
    public func responseJSONCC(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) -> CancellablePromise<(json: Any, response: PMKAlamofireDataResponse)> {
        return CancellablePromise(task: self, self.responseJSON(queue: queue, options: options))
    }
    
    public func responsePropertyListCC(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions()) -> CancellablePromise<(plist: Any, response: PMKAlamofireDataResponse)> {
        return CancellablePromise(task: self, self.responsePropertyList(queue: queue, options: options))
    }
    
    #if swift(>=3.2)
    public func responseDecodableCC<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder()) -> CancellablePromise<T> {
        return CancellablePromise(task: self, self.responseDecodable(queue: queue, decoder: decoder))
    }
    
    public func responseDecodableCC<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder()) -> CancellablePromise<T> {
        return CancellablePromise(task: self, self.responseDecodable(type, queue: queue, decoder: decoder))
    }
    #endif
}

extension Alamofire.DownloadRequest {
    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil) -> CancellablePromise<DefaultDownloadResponse> {
        return CancellablePromise(task: self, self.response(.promise, queue: queue))
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil) -> CancellablePromise<DownloadResponse<Data>> {
        return CancellablePromise(task: self, self.responseData(queue: queue))
    }
}
