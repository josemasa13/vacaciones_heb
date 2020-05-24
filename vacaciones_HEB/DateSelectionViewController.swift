//
//  DateSelectionViewController.swift
//  vacaciones_HEB
//
//  Created by Ricardo Ramirez on 21/05/20.
//  Copyright © 2020 José Alberto Marcial Sánchez. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateSelectionViewController: UIViewController {

    @IBOutlet var calendarView: JTAppleCalendarView!
    
    let months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var selectedDates: UILabel!
    @IBOutlet weak var aceptarBtn: UIButton!
    
    let formatter = DateFormatter()
    var datesToDeselect: [Date]?
    var dateSelect = Date()
    
    var delegate:CalendarDelegate?
    var startDate = Date()
    var endDate = Date()
    var isSelected = true
    var isClear = true
    var isClearDates = false
    var datesRange = -1
    
    let backgroudViewColor = UIColor.init(red: 230/255, green: 0, blue: 0, alpha: 0.5)

    
    @IBAction func nextMonth(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        // maybe no hacer nada
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        Utility.backToPreviousScreen(self)
    }
    
    @IBAction func aceptarBtn(_ sender: Any) {
        self.delegate?.didUpdatedDates(startDate, endDate, self.selectedDates.text ?? "All time")
        Utility.backToPreviousScreen(self)
    }
    
    func initData(_ dates: [Date]) {
        
        calendarView.selectDates(
            from: dates.first!,
            to: dates.last!,
            triggerSelectionDelegate: true,
            keepSelectionIfMultiSelectionAllowed: true)
        
        calendarView.reloadData()
    }
    
    func initDate(){
        if let firstDate = calendarView.selectedDates.first, let lastDate = calendarView.selectedDates.last {
            selectedDates.text = convertDateFormat(firstDate) + " to " + convertDateFormat(lastDate)
            startDate = firstDate
            endDate = lastDate
        }
    }
    
    let df = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDataSource  = self
        calendarView.calendarDelegate  = self
        // TODO: maybe tamaño
        
        aceptarBtn.layer.cornerRadius = 15
        aceptarBtn.layer.masksToBounds = true
        
        let date = Date()
        self.calendarView.scrollToDate(date, animateScroll: false)
        
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = true
        calendarView.minimumInteritemSpacing = 0
        calendarView.minimumLineSpacing = 0
        activeButton()
    }
    func activeButton() {
        if calendarView.selectedDates.count == 0 {
            aceptarBtn.isEnabled = false
            aceptarBtn.backgroundColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1)
            aceptarBtn.setTitleColor(UIColor(red:102/255, green:102/255, blue:102/255, alpha:1), for: .normal)
            selectedDates.text = "Please choose a date or date range to filter the SOS Band activities."
            selectedDates.isHidden = true
        } else {
            aceptarBtn.isEnabled = true
            aceptarBtn.backgroundColor = UIColor.red
            aceptarBtn.setTitleColor(UIColor.white, for: .normal)
            if calendarView.selectedDates.count == 1 {
                selectedDates.text = convertDateFormat(calendarView.selectedDates.first!)
            } else {
                selectedDates.text = "Your selected dates:"
            }
            selectedDates.isHidden = false
        }
        
    }
    
    func setupMonthLabel(date: Date) {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let year = String(anchorComponents.year ?? 2020)
        let month = anchorComponents.month ?? 1
        
        monthLabel.text = months[month-1]
        yearLabel.text = year
        
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? DateCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelection(cell: DateCell, cellState: CellState) {
            if cellState.dateBelongsTo == .thisMonth {
                cell.selectedView.isHidden = !cellState.isSelected
                print("Position: \(cellState.selectedPosition())")
                switch cellState.selectedPosition() {
                case .left:
                    cell.circleView.isHidden = false
                    cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                    
                    cell.selectedView.backgroundColor = backgroudViewColor
                    cell.selectedView.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                    cell.dateLabel.textColor = .white
                case .middle:
                    cell.circleView.isHidden = true
                    cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                    
                    cell.selectedView.backgroundColor = backgroudViewColor
                    cell.selectedView.roundCorners([], radius: 0)
                    cell.dateLabel.textColor = .white
                case .right:
                    cell.circleView.isHidden = false
                    cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                    
                    cell.selectedView.backgroundColor = backgroudViewColor
                    cell.selectedView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                    cell.dateLabel.textColor = .white
                case .full:
                    cell.circleView.isHidden = false
                    cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                    
                    cell.selectedView.backgroundColor = backgroudViewColor
                    cell.selectedView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                    cell.selectedView.isHidden = true
                    cell.dateLabel.textColor = .white
                default:
                    cell.circleView.isHidden = true
                    break
                }
            } else {
                cell.selectedView.isHidden = true
                cell.circleView.isHidden = true
            }
        }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DateSelectionViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! DateCell
        cell.dateLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        if cellState.dateBelongsTo == .thisMonth {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        activeButton()
        isSelected = false
        //if (calendar.selectedDates.count > 1) {
        
        if (isClearDates) {
            self.isClearDates = false
            //calendar.deselectAllDates()
            calendar.selectDates(from: date, to: date)
            calendar.reloadData()
        }
        else
            if (calendar.selectedDates.count == 2) {
                let calen = Calendar.current
                // Replace the hour (time) of both dates with 00:00
                let date1 = calen.startOfDay(for: calendar.selectedDates.first!)
                let date2 = calen.startOfDay(for: calendar.selectedDates.last!)
                
                let components = calen.dateComponents([.day], from: date1, to: date2)
                datesRange = components.day! + 1
                
                initData(calendar.selectedDates)
                if date > calendar.selectedDates.first! {
                    selectedDates.text = convertDateFormat(calendar.selectedDates.first!) + " to " + convertDateFormat(date)
                    startDate = calendar.selectedDates.first!
                    endDate = date
                } else {
                    selectedDates.text = convertDateFormat(date) + " to " + convertDateFormat(calendar.selectedDates.last!)
                    startDate = date
                    endDate = calendar.selectedDates.last!
                }
        }
        
        if calendar.selectedDates.count == datesRange {
            self.isClearDates = true
            datesRange = -1
        }
        isClear = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        if isSelected {activeButton()}
        if (calendar.selectedDates.count == 1) {
            selectedDates.text = convertDateFormat(calendar.selectedDates.first!)
        } else{
            self.initDate()
        }
        isSelected = true
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = df.date(from: "2018 01 01")!
        let endDate = df.date(from: "2030 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        dateSelect = date
        datesToDeselect?.append(date)
        
        if (calendar.selectedDates.count == 0) {
            selectedDates.text = convertDateFormat(date)
            startDate = date
            endDate = date
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        let selectedDates = calendar.selectedDates
        dateSelect = date
        isSelected = true
        self.isClearDates = false
        
        if selectedDates.contains(date) {
            
            // remove dates from the last selected.
            //            if (selectedDates.count > 2 && selectedDates.first != date && selectedDates.last != date) {
            //                let indexOfDate = selectedDates.index(of: date)
            //                let dateBeforeDeselectedDate = selectedDates[indexOfDate!]
            //                calendar.deselectAllDates()
            //                calendar.selectDates(
            //                    from: selectedDates.first!,
            //                    to: dateBeforeDeselectedDate,
            //                    triggerSelectionDelegate: true,
            //                    keepSelectionIfMultiSelectionAllowed: true)
            //                calendar.reloadData()
            //            }
            
            if (selectedDates.count > 1 && isClear) {
                self.isClear = false
                calendar.deselectAllDates()
                calendar.selectDates(from: date, to: date)
                calendarView.reloadData(withanchor: date, completionHandler: {
                })
            }
            
        }
        
        return true
    }
    
}



class DateCell: JTAppleCell{
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var circleView: UIView!
}

extension DateSelectionViewController {
    func convertDateFormat(_ date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // month
        let month = String(anchorComponents.month ?? 1)
        
        // day of month
        let day = String(anchorComponents.day ?? 1)
        
        // year
        let year = String(anchorComponents.year ?? 2018)
        
        let result = String(format: "%1$@-%2$@-%3$@", day, month, year)
        return result
    }
}

extension UIView {
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
