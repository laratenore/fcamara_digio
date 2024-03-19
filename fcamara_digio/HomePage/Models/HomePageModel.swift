import Foundation

public struct HomePageModel: Codable {
    let spotlight: [Spotlight]
    let products: [Product]
    let cash: Cash
}

public struct Spotlight: Codable {
    let name: String
    let bannerURL: String
    let description: String
}

public struct Product: Codable {
    let name: String
    let imageURL: String
    let description: String
}

public struct Cash: Codable {
    let title: String
    let bannerURL: String
    let description: String
}
