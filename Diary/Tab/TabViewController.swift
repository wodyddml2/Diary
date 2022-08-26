import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        if #available(iOS 13.0, *) {
            setupTabBarAppearance()
        } else {
            setupTabBarStyle()
        }

    }
    
    func configureTabBar() {
        let firstVC = HomeViewController()
        firstVC.tabBarItem.title = "Home"
        firstVC.tabBarItem.image = UIImage(systemName: "house")
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let firstNav = UINavigationController(rootViewController: firstVC)

        let secondVC = SearchViewController()
        secondVC.tabBarItem.title = "Search"
        secondVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        let thirdVC = SettingViewController()
        thirdVC.tabBarItem.title = "Setting"
        thirdVC.tabBarItem.image = UIImage(systemName: "house")
        thirdVC.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
//        let thirdNav = UINavigationController(rootViewController: thirdVC)
        
        setViewControllers([firstNav, secondNav, thirdVC], animated: true)
    }
    
    func setupTabBarAppearance() {
        // iOS 13 이후
        let appearence = UITabBarAppearance()
        // .configureWithTransparentBackground: 탭바의 배경을 투명하고 그림자 없는 막대모양개체로 구성
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .darkGray
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
        tabBar.tintColor = .white
    }
    
    func setupTabBarStyle() {
        tabBar.backgroundColor = .darkGray
        tabBar.tintColor = .white
    }
  

}
