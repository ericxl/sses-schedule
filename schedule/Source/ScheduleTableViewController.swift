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

    var schedule : SCSchedule!
    var displayingDayPeriod : SCDay!

    @IBOutlet weak var scheduleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.allowsSelectionDuringEditing = true;
        scheduleTableView.allowsSelection = false;
        
    }
    // MARK: - Table view data source

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


}

extension ScheduleTableViewController : UITableViewDelegate
{
}

// MARK: - Table view data source

extension ScheduleTableViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewRect : CGRect = scheduleTableView.frame
        return viewRect.height / CGFloat(self.tableView(scheduleTableView, numberOfRowsInSection: 0));
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableCellIdentifier", for: indexPath)
        let periodLabel = cell.viewWithTag(1) as! UILabel
        let classNameLabel = cell.viewWithTag(2) as! UILabel
        let teacherNameLabel = cell.viewWithTag(3) as! UILabel
        let locationLabel = cell.viewWithTag(4) as! UILabel
        let currentClass = schedule[SCDayPeriod(day: displayingDayPeriod, period: SCPeriod(rawValue: indexPath.row + 1)!)]

        periodLabel.text = String(indexPath.row + 1)
        classNameLabel.text = currentClass?.name
        teacherNameLabel.text = currentClass?.teacher
        locationLabel.text = currentClass?.location
        return cell
    }
}
