//
//  MockURLProtocol.swift
//  SearchGithubUnitTests
//
//  Created by Nicolas Nshuti on 14/11/2023.
//

import Foundation
import XCTest

// Below method is also useful. It contradicts what I knew and gives a good lesson👊🏾
// Reference: `https://medium.com/@dhawaldawar/how-to-mock-urlsession-using-urlprotocol-8b74f389a67a`
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        // To check if this protocol can handle the given request.
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Here you return the canonical version of the request but most of the time you pass the orignal one.
        return request
    }
    
    override func startLoading() {
        // This is where you create the mock response as per your test case and send it to the URLProtocolClient.
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            // 2. Call handler with received request and capture the tuple of response and data.
            let (response, data) = try handler(request)
            
            // 3. Send received response to the client.
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = data {
                // 4. Send received data to the client.
                client?.urlProtocol(self, didLoad: data)
            }
            
            // 5. Notify request has been finished.
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            // 6. Notify received error.
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
enum APIResponseError: Error {
    case network, parsing, request
}

class PostDetailAPI {
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchPostDetail(completion: @escaping (_ result: Result<Post, Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/42")!
        let dataTask = urlSession.dataTask(with:url) { (data, urlResponse, error) in
            do{
                // Check if any error occured.
                if let error = error {
                    throw error
                }
                
                // Check response code.
                guard let httpResponse = urlResponse as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    completion(Result.failure(APIResponseError.network))
                    return
                }
                
                // Parse data
                if let responseData = data, let object = try? JSONDecoder().decode(Post.self, from: responseData) {
                    completion(Result.success(object))
                } else {
                    throw APIResponseError.parsing
                }
            }catch{
                completion(Result.failure(error))
            }
        }
        
        dataTask.resume()
    }
}

class PostAPITest: XCTestCase {
    var postDetailAPI: PostDetailAPI!
    var expectation: XCTestExpectation!
    let apiURL = URL(string: "https://jsonplaceholder.typicode.com/posts/42")!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        postDetailAPI = PostDetailAPI(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }
    
    func testSuccessfulResponse() {
        // Prepare mock response.
        let userID = 5
        let id = 42
        let title = "URLProtocol Post"
        let body = "Post body...."
        let jsonString = """
                         {
                            "userId": \(userID),
                            "id": \(id),
                            "title": "\(title)",
                            "body": "\(body)"
                         }
                         """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.apiURL else {
                throw APIResponseError.request
            }
            
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API.
        postDetailAPI.fetchPostDetail { (result) in
            switch result {
            case .success(let post):
                XCTAssertEqual(post.userId, userID, "Incorrect userID.")
                XCTAssertEqual(post.id,  id, "Incorrect id.")
                XCTAssertEqual(post.title, title, "Incorrect title.")
                XCTAssertEqual(post.body, body, "Incorrect body.")
            case .failure(let error):
                XCTFail("Error was not expected: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testParsingFailure() {
        // Prepare response
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.apiURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API.
        postDetailAPI.fetchPostDetail { (result) in
            switch result {
            case .success(_):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                guard let error = error as? APIResponseError else {
                    XCTFail("Incorrect error received.")
                    self.expectation.fulfill()
                    return
                }
                
                XCTAssertEqual(error, APIResponseError.parsing, "Parsing error was expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
