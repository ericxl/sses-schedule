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

    private lazy var orderedViewControllers: [ScheduleTableViewController] = { SCDay.allCases.map({ mainTableViewController($0.rawValue) })
    }()
    private var isEditingSchedule: Bool = false {
        didSet {
            guard oldValue != isEditingSchedule else { return }
            guard let vc = viewControllers?.first as? ScheduleTableViewController else { return }
            vc.scheduleTableView.setEditing(isEditingSchedule, animated: true)
            self.dataSource = isEditingSchedule ? nil : self
        }
    }
    private var canToggleEditing: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.organize, target: self, action: #selector(handleEdit))
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        for controler in orderedViewControllers {
            controler.displayingDayPeriod = SCDay(rawValue: controler.title!)
        }
        DispatchQueue.global().async {
            var day = SCDay.A
            if let letterDay = try? SCDay(rawValue: String(String(contentsOf: URL(string: "http://apache.sstx.org/letterday/letterDayJson.php")!).suffix(4).first!))  {
                day = letterDay
            }
            DispatchQueue.main.async { [unowned self] in
                let firstViewController = self.orderedViewControllers[SCDay.allCases.firstIndex{ $0.rawValue == day.rawValue }!]
                self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: { [unowned self] _ in
                    self.updateTitle()
                })
            }
        }
    }

    private func mainTableViewController(_ letterDay: String) -> ScheduleTableViewController {
        let tableController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTableViewController") as! ScheduleTableViewController
        tableController.title = letterDay
        tableController.view.tag = Int(Character(letterDay).asciiValue! - Character("A").asciiValue!)
        return tableController
    }

    @objc func handleEdit() {
        if canToggleEditing {
            isEditingSchedule = !isEditingSchedule
        }
    }

    private func updateTitle() {
        guard let vc = viewControllers?.first else { return }
        navigationItem.title = SCDay.allCases[vc.view.tag].rawValue
    }
}

// MARK: UIPageViewControllerDelegate

extension MainViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        canToggleEditing = false

        var s1 = SCSchedule()
        s1.put(class: SCClass(name: "English"), dayPeriod: .A1)
        s1.put(class: SCClass(name: "History"), dayPeriod: .A2)
        s1.put(class: SCClass(name: "Math"), dayPeriod: .A3)
        s1.put(class: SCClass(name: "Music"), dayPeriod: .A5)
        (UIApplication.shared.delegate as! AppDelegate).data.add(user: "", schedule: s1)
        if let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data"), let encoded = try? JSONEncoder().encode((UIApplication.shared.delegate as! AppDelegate).data) {
            try? encoded.write(to: fileURL)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            canToggleEditing = true
        }
        updateTitle()
    }
}

// MARK: UIPageViewControllerDataSource

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController as! ScheduleTableViewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0, orderedViewControllers.count > previousIndex else { return nil }
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of:viewController as! ScheduleTableViewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex, orderedViewControllersCount > nextIndex else { return nil }
        return orderedViewControllers[nextIndex]
    }
}
