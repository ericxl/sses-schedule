//
//  MainViewController.swift
//  sses-schedule
//
//  Created by Eric Liang on 4/2/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import UIKit

class MainViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        view.backgroundColor = UIColor.white
        
        let left : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(handleEdit))
        let right : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(handleCancel))
        left.tintColor = UIColor.white
        right.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        let schedule = SSSchedule()
        schedule["A3"] = SSClass("Dancing", teacher: "Dr. Shit")
        schedule["A", 6] = SSClass("English 10", teacher: "Hewllet", location: "Random place")
        
        for controler in orderedViewControllers {
            controler.schedule = schedule
        }
        // Do any additional setup after loading the view.
    }
    
    private(set) lazy var orderedViewControllers: [ScheduleTableViewController] = {
        print("asking orderedViewControllers")
        return [self.mainTableViewController("A"),
                self.mainTableViewController("B"),
                self.mainTableViewController("C"),
                self.mainTableViewController("D"),
                self.mainTableViewController("E"),
                self.mainTableViewController("F"),
                self.mainTableViewController("G")]
    }()
    
    private func mainTableViewController(_ letterDay: String) -> ScheduleTableViewController {
        let tableController : ScheduleTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! ScheduleTableViewController
        tableController.title = letterDay
        return tableController
    }
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Navigation

    @objc func handleCancel()
    {
        
    }
    
    @objc func handleEdit()
    {
        
    }
}

// MARK: UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return orderedViewControllers.index(of: self.viewControllers?[0] as! ScheduleTableViewController)!
//    }
}

// MARK: UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController as! ScheduleTableViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController as!ScheduleTableViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}
