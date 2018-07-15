//
//  TutorialPageViewController.swift
//  videoCallPrincess
//
//  Created by Colter Conway on 5/20/18.
//  Copyright © 2018 Colter Conway. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vcOne = sb.instantiateViewController(withIdentifier: "pageOne")
        let vcTwo = sb.instantiateViewController(withIdentifier: "pageTwo")
        let vcThree = sb.instantiateViewController(withIdentifier: "pageThree")
        
        return [vcOne, vcTwo, vcThree]
    }()
    
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.delegate = self
        configurePageControl()

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = vcIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: UIScreen.main.bounds.maxX/2,y: UIScreen.main.bounds.minY + (UIScreen.main.bounds.maxY*(40/736)),width: 0,height: 0))
        self.pageControl.numberOfPages = viewControllerList.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor(red:1.00, green:0.54, blue:0.73, alpha:1.0)
        self.pageControl.pageIndicatorTintColor = UIColor(red:0.83, green:0.82, blue:0.83, alpha:1.0)
        self.pageControl.currentPageIndicatorTintColor = UIColor(red:1.00, green:0.54, blue:0.73, alpha:1.0)
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.index(of: pageContentViewController)!
    }
}
