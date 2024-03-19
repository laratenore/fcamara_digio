import Foundation
import XCTest

@testable import fcamara_digio

class HomePageViewModelTests: XCTestCase {
    let dataStoreSpy = HomePageDataStore()
    let workerSpy = HomePageWorkerInterfaceSpy()
    let delegateSpy = HomePageViewModelDelegateSpy()
    lazy var sut: HomePageViewModel = {
        let sut = HomePageViewModel(worker: workerSpy, dataStore: dataStoreSpy)
        sut.delegate = delegateSpy
        return sut
    }()

    func test_getCharacters_shouldCallSuccess() {
        dataStoreSpy.products = []
        workerSpy.getCharactersCompletion = .success(HomePageModel(spotlight: [Spotlight(name: "Spotlight", bannerURL: "", description: "spotlight description")], products: [Product(name: "Product", imageURL: "", description: "product description")], cash: Cash(title: "Cash", bannerURL: "", description: "cash description")))

        sut.fetchHomeProducts()

        XCTAssertTrue(workerSpy.fetchHomeProductsCalled)
        XCTAssertTrue(delegateSpy.fetchHomeProductsSuccessCalled)
        XCTAssertEqual(dataStoreSpy.products.count, 3)
    }
}
