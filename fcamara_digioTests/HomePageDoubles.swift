import Foundation
import UIKit

@testable import fcamara_digio

class HomePageViewModelInterfaceSpy: HomePageViewModelInterface {
    var delegate: HomePageViewModelDelegate? = nil
    
    private(set) var fetchHomeProductsCalled = false
    func fetchHomeProducts() {
        fetchHomeProductsCalled = true
    }
    
    private(set) var getHomePageConfigurationCalled = false
    var getHomePageConfigurationReturn: HomePageView.Configuration = HomePageView.Configuration(banners: [])
    func getHomePageConfiguration() -> HomePageView.Configuration {
        getHomePageConfigurationCalled = true
        return getHomePageConfigurationReturn
    }
}

class HomePageViewModelDelegateSpy: HomePageViewModelDelegate {
    private(set) var fetchHomeProductsSuccessCalled = false
    func fetchHomeProductsSuccess() {
        fetchHomeProductsSuccessCalled = true
    }
}

final class HomePageViewDelegateSpy: HomePageViewDelegate {
    private(set) var didSelectBannerCalled = false
    private(set) var didSelectBannerPassed: String?
    func didSelectBanner(productId: String) {
        didSelectBannerCalled = true
        didSelectBannerPassed = productId
    }
    
}

final class HomePageViewInterfaceSpy: UIView, HomePageViewInterface {
    var delegate: HomePageViewDelegate? = nil
    
    private(set) var buildCalled = false
    private(set) var buildPassed: HomePageView.Configuration?
    func build(configuration: HomePageView.Configuration) {
        buildCalled = true
        buildPassed = configuration
    }
}

final class HomePageWorkerInterfaceSpy: HomePageWorkerInterface {
    
    private(set) var fetchHomeProductsCalled = false
    var getCharactersCompletion: Result<HomePageModel, Error>?
    
    func fetchHomeProducts(completion: @escaping (Result<HomePageModel, Error>) -> Void) {
        fetchHomeProductsCalled = true
        guard let value = getCharactersCompletion else { return }
        completion(value)
    }
}
