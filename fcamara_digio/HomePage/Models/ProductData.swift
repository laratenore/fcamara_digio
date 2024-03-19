import Foundation

struct ProductData: Decodable {
    let productId: String
    let productType: ProductType
    let productName: String
    let productURL: String
    let productDescription: String
}
