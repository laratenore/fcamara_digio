import Foundation
import XCTest

@testable import fcamara_digio

class HomePageViewControllerTests: XCTestCase {
    let viewSpy = HomePageViewInterfaceSpy()
    let viewModelSpy = HomePageViewModelInterfaceSpy()
    lazy var sut = HomePageViewController(viewModel: viewModelSpy, customView: viewSpy)

    func test_getCharacterSuccess_shouldCallReloadData() {
        sut.fetchHomeProductsSuccess()

        XCTAssertTrue(viewSpy.buildCalled)
    }

    func test_viewDidLoad_shouldCallGetCharacters() {
        sut.viewDidLoad()

        XCTAssertTrue(viewModelSpy.fetchHomeProductsCalled)
    }
}
