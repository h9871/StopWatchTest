//
//  ViewController.swift
//  TimeWatchTest
//
//  Created by 유현재 on 07/03/2020.
//  Copyright © 2020 유현재. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 시작과 기록의 상태
    enum WatchStatus {
        case start
        case stop
    }

    /// 기록 표시 테이블
    @IBOutlet weak var timeTableView: UITableView!
    
    /// 타임 표시 라벨
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var milliSecondLabel: UILabel!
    
    /// 조작 버튼
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    /// 기록을 보존 하는 리스트
    var recordList: [String] = []
    
    /// 버튼의 상태
    var watchStatus: WatchStatus = .start
    
    /// 타이머 설정
    var timer: Timer!
    /// 시작 시간
    var startTime =  Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeTableView.delegate = self
        self.timeTableView.dataSource = self
        self.timeTableView.backgroundColor = .green
        self.timeTableView.separatorStyle = .none
    }
    
    @IBAction func didTappedStartButton(_ sender: UIButton) {
        switch self.watchStatus {
        case .start:
            self.watchStatus = .stop
            self.timer = Timer.scheduledTimer(timeInterval: 0.001,
                                              target: self,
                                              selector: #selector(timeUp),
                                              userInfo: nil,
                                              repeats: true)
            self.startTime = Date()
            
            self.setButton("Stop")
        case .stop:
            let hour = self.hourLabel.text ?? ""
            let minute = self.minuteLabel.text ?? ""
            let second = self.secondLabel.text ?? ""
            let milliSecond = self.milliSecondLabel.text ?? ""
            
            let record = "\(hour) : \(minute) : \(second) : \(milliSecond)"
            self.recordList.append(record)
            
            self.timeTableView.reloadData()
            self.tableViewBottomScroll()
        }
    }
    
    @IBAction func didTappedResetButton(_ sender: UIButton) {
        if self.recordList.isEmpty {
            self.watchStatus = .start
            
            self.timer.invalidate()
            
            self.hourLabel.text = "00"
            self.minuteLabel.text = "00"
            self.secondLabel.text = "00"
            self.milliSecondLabel.text = "000"
            
            self.setButton("Start")
        } else {
            self.recordList.removeAll()
            self.timeTableView.reloadData()
        }
    }
    
    @objc
    private func timeUp() {
        let timeInterval = Date().timeIntervalSince(self.startTime)
        
        let hour = (Int)(fmod((timeInterval/60/60), 12))
        let minute = (Int)(fmod((timeInterval/60), 60))
        let second = (Int)(fmod(timeInterval, 60))
        let milliSecond = (Int)((timeInterval - floor(timeInterval))*1000)
        
        self.hourLabel.text = String(format:"%02d", hour)
        self.minuteLabel.text = String(format:"%02d", minute)
        self.secondLabel.text = String(format:"%02d", second)
        self.milliSecondLabel.text = String(format:"%03d", milliSecond)
    }
}

extension ViewController {
    private func setButton(_ string: String) {
        self.startButton.setTitle(string, for: .normal)
        self.startButton.setTitle(string, for: .highlighted)
    }
    
    private func tableViewBottomScroll() {
        let numberOfSections = self.timeTableView.numberOfSections
        let numberOfRows = self.timeTableView.numberOfRows(inSection: numberOfSections - 1)
        let lastPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
        self.timeTableView.scrollToRow(at: lastPath, at: .bottom, animated: true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.recordList[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = .clear
        return cell
    }
}
