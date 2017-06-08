//
//  CalendarViewController.swift
//  mynurzSDK
//
//  Created by Robyarta on 6/7/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EZSwiftExtensions

class CalendarViewController: UIViewController {

    @IBOutlet weak var detailView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    let dummySchedule = [
        "2017 06 02":["siang","malam"],
        "2017 06 05":["malam"],
        "2017 06 08":["siang"]
    ]
    var detailData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.minimumLineSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.minimumInteritemSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.isRangeSelectionUsed = false
        calendarView.allowsMultipleSelection = false
        detailView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleSelectedCell(view: JTAppleCell?, date: Date, cellState: CellState){
        guard let validCell = view as? CustomCalendarCell else {return}
        if validCell.isSelected {
            validCell.addBorder(width: 1, color: UIColor.black)
        }else{
            validCell.addBorder(width: 1, color: UIColor.white)
        }
    }
    
    func handleScheduleMark(view: JTAppleCell?, date: Date, cellState: CellState){
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
            validCell.shiftSession08.backgroundColor = UIColor.clear
            validCell.shiftSession12.backgroundColor = UIColor.clear
            validCell.shiftSession16.backgroundColor = UIColor.clear
            validCell.shiftSession20.backgroundColor = UIColor.clear
        }else{
            validCell.shiftSiang.backgroundColor = UIColor.clear
            validCell.shiftMalam.backgroundColor = UIColor.clear
            validCell.shiftSession08.backgroundColor = UIColor.clear
            validCell.shiftSession12.backgroundColor = UIColor.clear
            validCell.shiftSession16.backgroundColor = UIColor.clear
            validCell.shiftSession20.backgroundColor = UIColor.clear
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
        return ConfigurationParameters(startDate: startDate,endDate: endDate)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let validCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCalendarCell else {
            return JTAppleCell(x: 0, y: 0, w: 75, h: 75)
        }
        validCell.dateLabel.text = cellState.text
        if cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = UIColor.black
        }else{
            validCell.dateLabel.textColor = UIColor.lightGray
        }
        self.handleSelectedCell(view: validCell, date: date, cellState: cellState)
        self.handleScheduleMark(view: validCell, date: date, cellState: cellState)
        return validCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell else{return}
        if let validData = self.dummySchedule[date.toString(format: self.formatter.dateFormat)] {
            self.detailData = validData
        }else{
            self.detailData = [String]()
        }
        detailView.reloadData()
        self.handleSelectedCell(view: validCell, date: date, cellState: cellState)
        self.handleScheduleMark(view: validCell, date: date, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell else{return}
        self.handleSelectedCell(view: validCell, date: date, cellState: cellState)
        self.handleScheduleMark(view: validCell, date: date, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "headerLabel", for: indexPath)
        if let validLabel = header.viewWithTag(100) as? UILabel {
            validLabel.text = "\(range.start.monthAsString) \(range.start.year)"
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
    @IBOutlet weak var shiftSession08: UIView!
    @IBOutlet weak var shiftSession12: UIView!
    @IBOutlet weak var shiftSession16: UIView!
    @IBOutlet weak var shiftSession20: UIView!
}
