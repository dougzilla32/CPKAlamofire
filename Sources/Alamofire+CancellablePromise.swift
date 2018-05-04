//
//  Alamofire+CancellablePromise.swift
//  CancellablePromiseKit
//
//  Created by Doug on 4/28/18.
//  Copyright © 2018 Doug Stein. All rights reserved.
//

import Alamofire
import PromiseKit
#if !CPKCocoaPods
import CancellablePromiseKit
#endif

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
    public func response(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelMode) -> Promise<(URLRequest, HTTPURLResponse, Data)> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseData(queue: DispatchQueue? = nil, cancel: CancelMode) -> Promise<(data: Data, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseString(queue: DispatchQueue? = nil, cancel: CancelMode) -> Promise<(string: String, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseJSON(queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, cancel: CancelMode) -> Promise<(json: Any, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responsePropertyList(queue: DispatchQueue? = nil, options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(), cancel: CancelMode) -> Promise<(plist: Any, response: PMKAlamofireDataResponse)> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelMode) -> Promise<T> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseDecodable<T: Decodable>(_ type: T.Type, queue: DispatchQueue? = nil, decoder: JSONDecoder = JSONDecoder(), cancel: CancelMode) -> Promise<T> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func response(_: PMKNamespacer, queue: DispatchQueue? = nil, cancel: CancelMode) -> Promise<DefaultDownloadResponse> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
    public func responseData(queue: DispatchQueue? = nil, cancel: CancelMode) -> Promise<DownloadResponse<Data>> {
        return Promise(task: RequestTask(self), cancel: cancel) { seal in
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
