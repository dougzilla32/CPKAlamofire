import Alamofire
import PromiseKit
#if !CPKCocoaPods
import CancelForPromiseKit
#endif

extension Request: CancellableTask {
    public var isCancelled: Bool {
        get {
            return task?.state == .canceling
        }
    }
}

extension Alamofire.DataRequest {
    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(URLRequest, HTTPURLResponse, Data)> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.response(queue: queue) { rsp in
                if let error = rsp.error {
                    seal.reject(error)
                } else if let a = rsp.request, let b = rsp.response, let c = rsp.data {
                    seal.fulfill((a, b, c))
                } else {
                    seal.reject(PMKError.invalidCallingConvention)
                }
            }
        }
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(data: Data, response: PMKAlamofireDataResponse)> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseData(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func responseStringCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<(string: String, response: PMKAlamofireDataResponse)> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseString(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func responseJSONCC(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, cancel: CancelContext? = nil) -> Promise<(json: Any, response: PMKAlamofireDataResponse)> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseJSON(queue: queue, options: options) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func responsePropertyListCC(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(), cancel: CancelContext? = nil) -> Promise<(plist: Any, response: PMKAlamofireDataResponse)> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responsePropertyList(queue: queue, options: options) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    #if swift(>=3.2)
    /**
     Returns a Promise for a Decodable
     Adds a handler to be called once the request has finished.
     
     - Parameter queue: DispatchQueue, by default nil
     - Parameter decoder: JSONDecoder, by default JSONDecoder()
     */
    public func responseDecodableCC<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelContext? = nil) -> Promise<T> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseData(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    do {
                        seal.fulfill(try decoder.decode(T.self, from: value))
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    /**
     Returns a Promise for a Decodable
     Adds a handler to be called once the request has finished.
     
     - Parameter queue: DispatchQueue, by default nil
     - Parameter decoder: JSONDecoder, by default JSONDecoder()
     */
    public func responseDecodableCC<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelContext? = nil) -> Promise<T> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseData(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    do {
                        seal.fulfill(try decoder.decode(type, from: value))
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    #endif
}

extension Alamofire.DownloadRequest {
    public func responseCC(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<DefaultDownloadResponse> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.response(queue: queue) { response in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    seal.fulfill(response)
                }
            }
        }
    }
    
    public func responseDataCC(queue: DispatchQueue? = nil, cancel: CancelContext? = nil) -> Promise<DownloadResponse<Data>> {
        let cancelContext = cancel ?? CancelContext()
        return Promise(cancel: cancelContext, task: self) { seal in
            self.responseData(queue: queue) { response in
                switch response.result {
                case .success:
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}
