import Foundation

protocol HomePageWorkerInterface {
    func fetchHomeProducts(completion: @escaping (Result<HomePageModel, Error>) -> Void)
}

class HomePageWorker: HomePageWorkerInterface {
    func fetchHomeProducts(completion: @escaping (Result<HomePageModel, Error>) -> Void) {
        let url = URL(string: Constants.dataUrl)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            if let homePageData = try? JSONDecoder().decode(HomePageModel.self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(homePageData))
                }
            }
        }
        task.resume()
    }
    
    
}

private extension HomePageWorker {
    enum Constants {
        static let dataUrl = "https://7hgi9vtkdc.execute-api.sa-east-1.amazonaws.com/sandbox/products"
    }
}
