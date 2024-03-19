import UIKit

class HomePageViewController: UIViewController {
    private var viewModel: HomePageViewModelInterface
    private var customView: UIView & HomePageViewInterface
    
    init(viewModel: HomePageViewModelInterface = HomePageViewModel(),
         customView: UIView & HomePageViewInterface = HomePageView()
    ) {
        self.viewModel = viewModel
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.view.backgroundColor = .white
        self.customView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        viewModel.fetchHomeProducts()
    }
    
    override func loadView() {
        self.view = self.customView
    }
}

extension HomePageViewController: HomePageViewModelDelegate {
    func fetchHomeProductsSuccess() {
        customView.build(configuration: viewModel.getHomePageConfiguration())
    }
}

extension HomePageViewController: HomePageViewDelegate {
    func didSelectBanner(productId: String) {
        //TODO: Route to new ProductDetailViewController (clean push)
    }
}
