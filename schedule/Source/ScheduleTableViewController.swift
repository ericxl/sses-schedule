//
//  ScheduleTableViewController.swift
//  sses-schedule
//
//  Created by Eric Liang on 4/2/19.
//  Copyright © 2019 Eric Liang. All rights reserved.
//

import UIKit
import ScheduleCore
class ScheduleTableViewController: UIViewController {

    var schedule : SCSchedule {
        (UIApplication.shared.delegate as! AppDelegate).schedule
    }
    var displayingDayPeriod : SCDay!

    @IBOutlet weak var scheduleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.allowsSelectionDuringEditing = true;
        scheduleTableView.allowsSelection = false;
    }
}

// MARK: - Table view delegate

extension ScheduleTableViewController : UITableViewDelegate { }

// MARK: - Table view data source

extension ScheduleTableViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { SCPeriod.allCases.count }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewRect = scheduleTableView.frame
        return viewRect.height / CGFloat(self.tableView(scheduleTableView, numberOfRowsInSection: 0));
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableCellIdentifier", for: indexPath)
        if let periodLabel = cell.viewWithTag(1) as? UILabel {
            periodLabel.text = String(indexPath.row + 1)
        }
        let currentClass = schedule[SCDayPeriod(day: displayingDayPeriod, period: SCPeriod(rawValue: indexPath.row + 1)!)]
        if let classNameLabel = cell.viewWithTag(2) as? UILabel {
            classNameLabel.text = currentClass?.name
        }
        if let teacherNameLabel = cell.viewWithTag(3) as? UILabel {
            teacherNameLabel.text = currentClass?.teacher
        }
        if let locationLabel = cell.viewWithTag(4) as? UILabel {
            locationLabel.text = currentClass?.location
        }
        return cell
    }
}
