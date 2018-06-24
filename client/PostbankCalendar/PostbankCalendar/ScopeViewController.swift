//
//  FSCalendarScopeViewController.swift
//  PostbankCalendar
//
//  Created by dingwenchao on 30/12/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit

class ScopeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Vars
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = { [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private var allEventGroups: [EventsModel] = [] {
        didSet {
            allEventGroups.forEach {
                $0.events.forEach {
                    datesWithEvent.append($0.startDate)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    private var datesWithEvent: [String] = [] {
        didSet {
            calendar.reloadData()
        }
    }
    
    private var selectedEvent: EventModel?
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        initializeCalendar(with: Date(), and: .month)
        
        let newDate = dateFormatter.string(from: Date())
        let dateComponents = newDate.split(separator: "/")
        let month = Int(dateComponents[1])
        let year = Int(dateComponents[2])
        send(currentYear: year!, and: month!)
    }
    
    deinit { // Remove if not needed
        print("\(#function)")
    }
    
    // MARK: Private
    
    private func initializeView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "postbank-banner")
        navigationItem.titleView = imageView
    }
    
    private func initializeCalendar(with date: Date, and scope: FSCalendarScope) {
        if UIDevice.current.model.hasPrefix("iPad") {
            calendarHeightConstraint.constant = 400
        }
        
        calendar.select(date)
        
        view.addGestureRecognizer(self.scopeGesture)
        tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        calendar.scope = scope
    }
    
    private func send(currentYear: Int, and currentMonth: Int) {
        PostbankAPI.sharedInstance.getAllEventsBy(year: currentYear, month: currentMonth) { [weak self] (response) in
            switch response.result {
            case .success(let success):
                self?.allEventGroups = success.result.eventGroups
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    // MARK: CalendarDataSource and CalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        let dateComponents = selectedDates.first!.split(separator: "/")
        
        let day = Int(dateComponents[0])!
        let month = Int(dateComponents[1])!
        let year = Int(dateComponents[2])!
        
        // MARK: To-do
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let newDate = dateFormatter.string(from: calendar.currentPage)
        let dateComponents = newDate.split(separator: "/")
        guard let month = Int(dateComponents[1]), let year = Int(dateComponents[2]) else {
            return
        }
        
        send(currentYear: year, and: month)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventColorFor date: Date) -> UIColor? {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return UIColor.purple
        }
        return nil
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allEventGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEventGroups[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!
        cell.textLabel?.text = allEventGroups[indexPath.section].events[indexPath.row].title
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "showEventDetails", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scopeSettings = segue.destination as? ScopeSettingsViewController {
            scopeSettings.selectedDate = calendar.selectedDate
            scopeSettings.firstWeekday = calendar.firstWeekday
            scopeSettings.scrollDirection = calendar.scrollDirection
        }
        
    }
    
    // MARK: IBAction
    
    @IBAction func addEventButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showEventDetails", sender: nil)
    }
    
    @IBAction func unwindToScope(segue: UIStoryboardSegue) {
        if let scopeSettings = segue.source as? ScopeSettingsViewController {
            if calendar.selectedDate != scopeSettings.selectedDate {
                calendar.select(scopeSettings.selectedDate, scrollToDate: true)
                let newScope: FSCalendarScope = calendar.scope.rawValue == 0 ? .week : .month
                calendar.setScope(newScope, animated: true)
            }
            if calendar.firstWeekday != scopeSettings.firstWeekday {
                calendar.firstWeekday = scopeSettings.firstWeekday
            }
            if calendar.scrollDirection != scopeSettings.scrollDirection {
                calendar.scrollDirection = scopeSettings.scrollDirection
            }
        }
    }
    
}
