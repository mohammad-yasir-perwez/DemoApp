import Foundation

// https://restcountries.com/v3.1/all
/// A type that can encode values into a native format for external
/// representation.
/// In this case, encoding represents serialization, while decoding signifies deserialization.
/// Whenever you serialize data, you convert it into an easily transportable format.
/// Once transported, it converts back into its original format. T
struct Country: Decodable, Equatable, Hashable {

    let name: String
    let population: Int
    let capital: [String]?
    let flagURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case population
        case capital
        case flagURL
        case flags

        enum NameCodingKeys: String, CodingKey {
            case official
        }

        enum FlagCodingKeys: String, CodingKey {
            case png
        }

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let nameObject = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        self.name = try nameObject.decode(String.self, forKey: CodingKeys.NameCodingKeys.official)
        self.population = try container.decode(Int.self, forKey: .population)
        self.capital = try container.decodeIfPresent([String].self, forKey: .capital)
        let flagURLContainer = try container.nestedContainer(keyedBy: CodingKeys.FlagCodingKeys.self, forKey: .flags)
        self.flagURL = try flagURLContainer.decode(String.self, forKey: CodingKeys.FlagCodingKeys.png)
    }
}

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

