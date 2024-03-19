import Foundation

public enum ProductType: Codable, CaseIterable {
    case spotlight
    case product
    case cash
}

protocol HomePageViewModelDelegate: AnyObject {
    func fetchHomeProductsSuccess()
}

protocol HomePageViewModelInterface {
    var delegate: HomePageViewModelDelegate? { get set }

    func fetchHomeProducts()
    func getHomePageConfiguration() -> HomePageView.Configuration
}

class HomePageViewModel: HomePageViewModelInterface {
    weak var delegate: HomePageViewModelDelegate?
    let worker: HomePageWorkerInterface
    var dataStore: HomePageDataStoreProtocol

    init(worker: HomePageWorkerInterface = HomePageWorker(),
         dataStore: HomePageDataStoreProtocol = HomePageDataStore()) {
        self.worker = worker
        self.dataStore = dataStore
    }

    func fetchHomeProducts() {
        worker.fetchHomeProducts() { result in
            switch result {
            case .success(let data):
                self.buildDataStore(data)
                self.delegate?.fetchHomeProductsSuccess()
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func getHomePageConfiguration() -> HomePageView.Configuration {
        let types = ProductType.allCases
        var banners: [BannerView.Configuration] = []
        types.forEach { type in
            let products = dataStore.products.filter { item in
                item.productType == type
            }
            banners.append(BannerView.Configuration(type: type, products: products))
            
        }
        return HomePageView.Configuration(banners: banners)
    }
    
    private func buildDataStore(_ data: HomePageModel) {
        data.spotlight.forEach { item in
            let spot = ProductData(
                productId: NSUUID().uuidString,
                productType: .spotlight,
                productName: item.name,
                productURL: item.bannerURL,
                productDescription: item.description
            )
            dataStore.products.append(spot)
        }
        
        data.products.forEach { item in
            let product = ProductData(
                productId: NSUUID().uuidString,
                productType: .product,
                productName: item.name,
                productURL: item.imageURL,
                productDescription: item.description
            )
            dataStore.products.append(product)
        }
        
        let cash = ProductData(
            productId: NSUUID().uuidString,
            productType: .cash,
            productName: data.cash.title,
            productURL: data.cash.bannerURL,
            productDescription: data.cash.description
        )
        dataStore.products.append(cash)
    }
}

