//
//  Alamofire+CancellablePromise.swift
//  CancellablePromiseKit
//
//  Created by Doug on 4/28/18.
//  Copyright © 2018 Doug Stein. All rights reserved.
//

import Alamofire
import PromiseKit
import CancellablePromiseKit

public class RequestTask: CancellableTask {
    private let task: Request
    
    init(_ task: Request) {
        self.task = task
    }

    public func cancel() {
        task.cancel()
    }
    
    public var isCancelled: Bool {
        get {
            return task.task?.state == .canceling
        }
    }
}

extension Alamofire.DataRequest {
    /// Adds a handler to be called once the request has finished.
    public func responseWithCancel(_: PMKNamespacer, queue: DispatchQueue? = nil, cancelContext: CancelContext? = nil) -> Promise<(URLRequest, HTTPURLResponse, Data)> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    
    /// Adds a handler to be called once the request has finished.
    public func responseDataWithCancel(queue: DispatchQueue? = nil, cancelContext: CancelContext? = nil) -> Promise<(data: Data, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    
    /// Adds a handler to be called once the request has finished.
    public func responseStringWithCancel(queue: DispatchQueue? = nil, cancelContext: CancelContext? = nil) -> Promise<(string: String, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    
    /// Adds a handler to be called once the request has finished.
    public func responseJSONWithCancel(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, cancelContext: CancelContext? = nil) -> Promise<(json: Any, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    
    /// Adds a handler to be called once the request has finished.
    public func responsePropertyListWithCancel(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(), cancelContext: CancelContext? = nil) -> Promise<(plist: Any, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    public func responseDecodableWithCancel<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancelContext: CancelContext? = nil) -> Promise<T> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    public func responseDecodableWithCancel<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancelContext: CancelContext? = nil) -> Promise<T> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
    public func responseWithCancel(_: PMKNamespacer, queue: DispatchQueue? = nil, cancelContext: CancelContext? = nil) -> Promise<DefaultDownloadResponse> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
            self.response(queue: queue) { response in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    seal.fulfill(response)
                }
            }
        }
    }
    
    /// Adds a handler to be called once the request has finished.
    public func responseDataWithCancel(queue: DispatchQueue? = nil, cancelContext: CancelContext? = nil) -> Promise<DownloadResponse<Data>> {
        return Promise(task: RequestTask(self), cancelContext: cancelContext) { seal in
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
