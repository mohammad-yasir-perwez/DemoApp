import Foundation

// https://restcountries.com/v3.1/all
/// A type that can encode values into a native format for external
/// representation.
/// In this case, encoding represents serialization, while decoding signifies deserialization.
/// Whenever you serialize data, you convert it into an easily transportable format.
/// Once transported, it converts back into its original format. T


extension RequestBuilder {

    static func getAllCountries() -> Request<[Country]> {
        Request<[Country]>(
            data: RequestData(
                path: "/v3.1/all",
                queryItems: [],
                method: .get
            )
        )
    }
}

