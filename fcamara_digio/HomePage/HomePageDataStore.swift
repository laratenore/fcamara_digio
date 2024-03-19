import Foundation
protocol HomePageDataStoreProtocol {
    var products: [ProductData] { get set }
}

class HomePageDataStore: HomePageDataStoreProtocol {
    var products: [ProductData] = []
}
