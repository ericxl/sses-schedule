//
//  MainViewController.swift
//  sses-schedule
//
//  Created by Eric Liang on 4/2/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import UIKit
import ScheduleCore

class MainViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
//        var sc = SCSchedule()
        
        let left : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(handleEdit))
        let right : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(handleCancel))
//        left.tintColor = UIColor.label
//        right.tintColor = UIColor.label
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }

        var schedule = SCSchedule()
        schedule.put(class: SCClass(name: "English"), dayPeriod: .A4)
        schedule.put(class: SCClass(name: "History"), dayPeriod: .A1, all: true)
        for controler in orderedViewControllers {
            controler.schedule = schedule
            controler.displayingDayPeriod = SCDay(rawValue: controler.title!)
        }
    }
    
    private(set) lazy var orderedViewControllers: [ScheduleTableViewController] = {
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
