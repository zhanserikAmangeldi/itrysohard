import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let profileManager = ProfileManager(delegate: nil)
        let imageLoader = ImageLoader()
        let viewModel = FeedSystem(profileManager: profileManager, imageLoader: imageLoader)
        
        let feedVC = FeedViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: feedVC)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
