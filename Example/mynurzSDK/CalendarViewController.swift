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
import MGSwipeTableCell

class CalendarViewController: UIViewController {

    @IBOutlet weak var detailView: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var counter = 0
    let formatter = DateFormatter()
    let dummySchedule = [
        "2017-06-02":["siang","malam"],
        "2017-06-05":["malam"],
        "2017-06-08":["siang"]
    ]
    var detailData = [String]()
    
    func getStartDate() -> Date? {
        return self.calendarView.selectedDates.first
    }
    
    func getStopDate() -> Date? {
        guard self.calendarView.selectedDates.first != self.calendarView.selectedDates.last else {return nil}
        return self.calendarView.selectedDates.last
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.minimumLineSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.minimumInteritemSpacing = CGFloat.leastNonzeroMagnitude
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = true
        detailView.tableFooterView = UIView()
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        guard let validGestureview = gesture.view else { return }
        var rangeSelectedDates = calendarView.selectedDates
        let point = gesture.location(in: validGestureview)
        
        if gesture.state == .began {
            calendarView.deselectAllDates(triggerSelectionDelegate: true)
        }
        
        if gesture.state == .changed {
            if let cellState = calendarView.cellStatus(at: point) {
                let date = cellState.date
                if !rangeSelectedDates.contains(date) {
                    let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                    for aDate in dateRange {
                        if !rangeSelectedDates.contains(aDate) {
                            rangeSelectedDates.append(aDate)
                        }
                    }
                    guard let validFirstSelectedDate = rangeSelectedDates.first else {return}
                    calendarView.selectDates(from: validFirstSelectedDate, to: date, keepSelectionIfMultiSelectionAllowed: true)
                } else {
                    let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                    let lastIndex = rangeSelectedDates.endIndex
                    let followingDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                    rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
                }
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll(keepingCapacity: false)
        }
    }

    
    func handleDefaultCell(view: JTAppleCell?, date: Date, cellState: CellState, selectedDates: [Date]){
        guard let validCell = view as? CustomCalendarCell else {return}
        validCell.dateLabel.text = cellState.text
        validCell.shiftSiang.backgroundColor = UIColor.clear
        validCell.shiftMalam.backgroundColor = UIColor.clear
        validCell.shiftSession08.backgroundColor = UIColor.clear
        validCell.shiftSession12.backgroundColor = UIColor.clear
        validCell.shiftSession16.backgroundColor = UIColor.clear
        validCell.shiftSession20.backgroundColor = UIColor.clear
        if cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = UIColor.black
        }else{
            validCell.dateLabel.textColor = UIColor.lightGray
        }
        switch cellState.selectedPosition() {
        case .left:
            // range date on left position
            validCell.addBorder(width: 1, color: UIColor.red)
            break
        case .right:
            // range date on right position
            validCell.addBorder(width: 1, color: UIColor.blue)
            break
        case .middle:
            // range date on middle position
            validCell.addBorder(width: 1, color: UIColor.black)
            break
        case .full:
            // single date
            validCell.addBorder(width: 1, color: UIColor.green)
            break
        default:
            validCell.addBorder(width: 1, color: UIColor.white)
            break
        }
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017-01-01")!
        let endDate = formatter.date(from: "2017-12-31")!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: false)
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let validCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCalendarCell else {
            return JTAppleCell(x: 0, y: 0, w: 75, h: 75)
        }
        self.handleDefaultCell(view: validCell, date: date, cellState: cellState, selectedDates: calendar.selectedDates)
        return validCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCalendarCell else {return}
        self.handleDefaultCell(view: validCell, date: date, cellState: cellState, selectedDates: calendar.selectedDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCalendarCell else {return}
        self.handleDefaultCell(view: validCell, date: date, cellState: cellState, selectedDates: calendar.selectedDates)
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

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailData.count
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let validCell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as? MGSwipeTableCell else {
            return UITableViewCell()
        }
        
        validCell.delegate = self
        
        validCell.textLabel?.text = detailData[indexPath.row]
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            (cell) -> Bool in
            self.detailData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            return false
        }
        
        let archiveButton = MGSwipeButton(title: "Archive", backgroundColor: .green) {
            (cell) -> Bool in
            self.detailData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
            return false
        }
        
        validCell.leftButtons = [archiveButton]
        validCell.leftSwipeSettings.transition = .clipCenter
        
        validCell.rightButtons = [deleteButton]
        validCell.rightSwipeSettings.transition = .clipCenter
        
        return validCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("displayed cell for :\(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("selected row for :\(indexPath)")
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

extension Array where Element: Hashable {
    func after(item: Element) -> Element? {
        guard let validIndex = self.index(of: item) else {return nil}
        guard let validItem = self.get(at: validIndex) else {return nil}
        return validItem
    }
}
