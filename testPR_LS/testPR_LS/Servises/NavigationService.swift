import UIKit

final public class NavigationService: NSObject {
    static public let shared = NavigationService()
    public override init() {}
    
    private var navigationController: UINavigationController?

    private var topViewController: UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else {
            return nil
        }
        return getTopViewController(from: rootVC)
    }
    
    private func getTopViewController(from root: UIViewController?) -> UIViewController? {
        if let presented = root?.presentedViewController {
            return getTopViewController(from: presented)
        } else if let nav = root as? UINavigationController {
            return getTopViewController(from: nav.visibleViewController)
        } else if let tab = root as? UITabBarController {
            return getTopViewController(from: tab.selectedViewController)
        } else {
            return root
        }
    }
    
    private func setRootViewController(window: UIWindow, viewController: UIViewController) {
        window.rootViewController = viewController
        window.overrideUserInterfaceStyle = .dark
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
    
    private func configureNavigationBarAppearance(nav navigationController: UINavigationController?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.secondMain
        
        appearance.titleTextAttributes = [
            .foregroundColor: Colors.text,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: Colors.text,
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = Colors.text
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
      
        
        self.navigationController = navigationController
    }
    
    private func firstStep() {
        DataManager.shared.userId = 1
    }
}

//MARK: Public
extension NavigationService {
    public func runApp(for window: UIWindow) {
        DataManager.shared.incrementLaunchCount()
        let storyboard = UIStoryboard(name: "MainViewController", bundle: .main)
        guard let mainVC = storyboard.instantiateViewController(
                identifier: "MainViewController"
              ) as? MainViewController else {
            return
        }

        let nav = UINavigationController(rootViewController: mainVC)
        navigationController = nav

        configureNavigationBarAppearance(nav: nav)

        setRootViewController(window: window, viewController: nav)
        
        if  DataManager.shared.launchCount == 1 {
            firstStep()
        }
        
        window.makeKeyAndVisible()
    }
    
    public func showCommentsViewController(for postId: Int) {
        let commentsVC = CommentsViewController(postId: postId)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        topViewController?.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    public func showUsersViewController() {
        let commentsVC = UsersViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        topViewController?.navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    public func goToBake() {
        navigationController?.popViewController(animated: true)
    }
}
