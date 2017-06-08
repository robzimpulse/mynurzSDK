//
//  CalendarViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var detailView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    let dummySchedule = [
        "2017 06 02":["siang","malam"],
        "2017 06 05":["session","malam"],
        "2017 06 08":["siang","session"]
    ]
    var detailData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.minimumLineSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.minimumInteritemSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.isRangeSelectionUsed = false
        detailView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleTextColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCalendarCell else {return}
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.isHidden = false
        }else{
            validCell.isHidden = true
        }
    }
    
    func handleScheduleMark(view: JTAppleCell?, date: Date){
        guard let validCell = view as? CustomCalendarCell else {return}
        if let validDate = dummySchedule[date.toString(format: formatter.dateFormat)] {
            if validDate.contains("siang") {
                validCell.shiftSiang.backgroundColor = UIColor.red
            }else{
                validCell.shiftSiang.backgroundColor = UIColor.clear
            }
            if validDate.contains("malam") {
                validCell.shiftMalam.backgroundColor = UIColor.green
            }else{
                validCell.shiftMalam.backgroundColor = UIColor.clear
            }
            if validDate.contains("session") {
                validCell.shiftSession.backgroundColor = UIColor.blue
            }else{
                validCell.shiftSession.backgroundColor = UIColor.clear
            }
        }else{
            validCell.shiftSiang.backgroundColor = UIColor.clear
            validCell.shiftMalam.backgroundColor = UIColor.clear
            validCell.shiftSession.backgroundColor = UIColor.clear
        }
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        return ConfigurationParameters(startDate: startDate,endDate: endDate,numberOfRows: 6,calendar: Calendar.current,generateInDates: .forAllMonths,generateOutDates: .tillEndOfRow,firstDayOfWeek: .monday,hasStrictBoundaries: true)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let validCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCalendarCell else {
            return JTAppleCell(x: 0, y: 0, w: 75, h: 75)
        }
        validCell.dateLabel.text = cellState.text
        self.handleScheduleMark(view: validCell, date: date)
        self.handleTextColor(view: validCell, cellState: cellState)
        return validCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        if let validData = dummySchedule[date.toString(format: formatter.dateFormat)] {
            self.detailData = validData
        }else{
            self.detailData = [String]()
        }
        detailView.reloadData()
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        calendar.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "headerLabel", for: indexPath)
        if let validLabel = header.viewWithTag(100) as? UILabel {
            validLabel.text = range.start.monthAsString
        }
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let validCell = tableView.dequeueReusableCell(withIdentifier: "dataCell") else {
            return UITableViewCell()
        }
        
        validCell.textLabel?.text = detailData[indexPath.row]
        
        return validCell
    }
    
}

class CustomCalendarCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
 
    @IBOutlet weak var shiftSiang: UIView!
    @IBOutlet weak var shiftMalam: UIView!
    @IBOutlet weak var shiftSession: UIView!
}
