//
//  Client.swift
//  Countries
//
//  Created by Melanija Grunte on 13/02/2025.
//

import Foundation

class Client {
    static let countriesEndpoint = "https://restcountries.com/v3.1/all"

    private let session: URLSession

    init() {
        session = URLSession.shared
    }

    func perform(request: URLRequest) async throws(NetworkingError) -> ClientResponse {
        do {
            let (data, response) = try await session.data(for: request)

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkingError.invalidStatusCode(statusCode: -1)
            }

            guard (200 ... 299).contains(statusCode) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }

            let clientResponse = ClientResponse(data: data, response: response)

            return clientResponse
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as EncodingError {
            throw .encodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw .otherError(innerError: error)
        }
    }

    static func flagEndpoint(for countryCode: String) -> URL {
        URL(string: "https://flagsapi.com/\(countryCode)/flat/32")!
    }
}

public struct ClientResponse {
    public let data: Data?
    public let response: URLResponse?

    public init(
        data: Data? = nil,
        response: URLResponse? = nil
    ) {
        self.data = data
        self.response = response
    }
}

extension ClientResponse {
    func map() -> Result<[Country], Error> {
        if let data = data {
            let decoder = JSONDecoder()
            do {
                let countries = try decoder.decode([Country].self, from: data)
                return .success(countries)
            } catch {
                return .failure(error)
            }
        } else {
            let unknownError = NSError(domain: "", code: -1, userInfo: nil)
            return .failure(unknownError)
        }
    }
}

enum NetworkingError: Error {
    case encodingFailed(innerError: EncodingError)
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)
}
