//
//  ViewController.swift
//  ICHackMenstraulGym
//
//  Created by Gavin Vasandani on 04/02/2023.
//

import UIKit
import WebKit
import SwiftUI

import SwiftUI

import UIKit

/*
 import UIKit

 class LineGraphView: UIView {
     
     var data = [Int]() {
         didSet {
             setNeedsDisplay()
         }
     }
     
     private let padding: CGFloat = 20.0
     
     override func draw(_ rect: CGRect) {
         guard data.count > 1 else { return }
         
         let width = rect.width - 2 * padding
         let height = rect.height - 2 * padding
         
         let maxValue = data.max() ?? 0
         let minValue = data.min() ?? 0
         let range = maxValue - minValue
         
         let path = UIBezierPath()
         let xStep = width / CGFloat(data.count - 1)
         let yScale = height / CGFloat(range)
         
         for (index, value) in data.enumerated() {
             let x = padding + CGFloat(index) * xStep
             let y = height + padding - (CGFloat(value - minValue) * yScale)
             if index == 0 {
                 path.move(to: CGPoint(x: x, y: y))
             } else {
                 path.addLine(to: CGPoint(x: x, y: y))
             }
         }
         
         UIColor.black.setStroke()
         path.lineWidth = 2.0
         path.stroke()
     }
 }

 class ViewController: UIViewController {

     let graphView = LineGraphView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         graphView.data = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
         graphView.backgroundColor = .white
         view.addSubview(graphView)
     }
 }

*/


class WatchListViewController: UIViewController { //WatchListVewController is current stats to check (ovulation, hormones)
//watch list is main homepage
    /*
    class LineGraphView: UIView {
        
        var data = [Int]() {
            didSet {
                setNeedsDisplay()
            }
        }
        
        private let padding: CGFloat = 20.0
        
        override func draw(_ rect: CGRect) {
            guard data.count > 1 else { return }
            
            let width = rect.width - 2 * padding
            let height = rect.height - 2 * padding
            
            let maxValue = data.max() ?? 0
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            let path = UIBezierPath()
            let xStep = width / CGFloat(data.count - 1)
            let yScale = height / CGFloat(range)
            
            for (index, value) in data.enumerated() {
                let x = padding + CGFloat(index) * xStep
                let y = height + padding - (CGFloat(value - minValue) * yScale)
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            UIColor.red.setStroke()
            path.lineWidth = 2.0
            path.stroke()
        }
    }
    
    let graphView = LineGraphView(frame: CGRect(x: 100, y: 500, width: 250, height: 200))
    */
    //var barView: UIView!
    let barView = UIView()
    let barWidth: CGFloat = 30.0
    
    let timerLabel = UILabel()
    let trackLayer = CAShapeLayer()
    let progressLayer = CAShapeLayer()
    var timer: Timer?
    var timeLeft =  Int.random(in: 40...80)//this is specific to a workout
    
    let restTimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Rest Timer"
        label.backgroundColor = .systemBackground
        return label
    }()
    
    var heartBeatTimer: Timer!
    var heartBeatCount = 0
    
    let baseline = 60
    
    /*let heartBeatLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        return label
    }()*/
    
    /*
    override func viewDidLoad() { //anything in this func scope is something present on screen
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupSearchController() //call searchController func
        setUpTitleView() //call func into scope which outputs a certain text (title)
        //setupCountdownTimer(...) //countdown timer func call with countdown seconds as input param
        setupTimerLabel()
        setupTrackLayer()
        setupProgressLayer()
        startTimer()
        let graphView = LineGraphView(frame: CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2))
        graphView.data = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        view.addSubview(graphView)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSearchController()
        setUpTitleView()
        setupTimerLabel()
        setupTrackLayer()
        setupProgressLayer()
        let resetButton = UIButton(type: .system)
                resetButton.setTitle("Reset", for: .normal)
                resetButton.translatesAutoresizingMaskIntoConstraints = false
                resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
                view.addSubview(resetButton)
                NSLayoutConstraint.activate([
                    resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    resetButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: -15)
                ])
                
                startTimer()
        view.addSubview(restTimerLabel)
                restTimerLabel.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    restTimerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    restTimerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                ])
        /*view.addSubview(heartBeatLabel)
                heartBeatLabel.translatesAutoresizingMaskIntoConstraints = false
                heartBeatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                heartBeatLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         */
                heartBeatTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(animateHeartBeat), userInfo: nil, repeats: true)
            /*barView.backgroundColor = .red
               barView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(barView)

               NSLayoutConstraint.activate([
                   barView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   barView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                   barView.widthAnchor.constraint(equalToConstant: barWidth),
               ])*/

                setupBar()
                animateBar()
        
        heartBeat.text = "Heartbeat: \(value)"
                heartBeat.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(heartBeat)
                NSLayoutConstraint.activate([
                    heartBeat.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: xPosition),
                    heartBeat.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yPosition)
                ])
               
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                    var minV = 0
                    let maxV = 100
                    let randomNumber = Int.random(in: minV...maxV)
                    if randomNumber >= 40 {
                        self.value = self.generateSpikeValue()
                        minV = 35
                    } else {
                        self.value = self.generateRandomValue()
                        minV = 0
                    }
                    self.heartBeat.text = "Heartbeat: \(self.value)"
                    self.value = max(self.value - 1, self.baseline)
                    
                }
            }
        
    func generateRandomValue() -> Int {
            let randomNumber = Int.random(in: -5...5)
            return baseline + randomNumber
        }
        
        func generateSpikeValue() -> Int {
            let randomSpike = Int.random(in: 30...40)
            return baseline + randomSpike
        }
    
    var value = 60
       
    let heartBeat = UILabel()
        
        var xPosition: CGFloat = 0
        var yPosition: CGFloat = 40
    
    
    
        /*graphView.data = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                graphView.backgroundColor = .systemBackground
        view.addSubview(graphView)*/
    func setupBar() {
            barView.backgroundColor = UIColor.red
            barView.frame = CGRect(x: view.center.x-25, y: view.center.y-55, width: 50, height: 0)
            view.addSubview(barView)
        }
        
        func animateBar() {
            UIView.animate(withDuration: 60/75, delay: 0, options: [.repeat, .autoreverse], animations: { //withDuration changes with heartrate
                self.barView.frame.size.height = 200
                self.barView.frame.origin.y = self.view.frame.height - 200
            })
        }
    
    
    func setupTimerLabel() {
        timerLabel.frame = CGRect(x: view.center.x - 50, y: view.center.y - 185, width: 100, height: 100)
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 60)
        view.addSubview(timerLabel)
    }
    
    func setupTrackLayer() {
        let center = CGPoint(x: view.center.x, y: view.center.y - 140)
        let circularPath = UIBezierPath(arcCenter: center, radius: 105, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        view.layer.addSublayer(trackLayer)
    }
    
    func setupProgressLayer() {
        let center = CGPoint(x: view.center.x, y: view.center.y - 140)
        let circularPath = UIBezierPath(arcCenter: center, radius: 105, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        progressLayer.path = circularPath.cgPath
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 1
        view.layer.addSublayer(progressLayer)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 1
        animation.toValue = 0
        animation.duration = TimeInterval(timeLeft)
        progressLayer.add(animation, forKey: "countdown")
    }
    
    @objc func updateTimer() {
        if timeLeft > 0 {
            timeLeft -= 1
            timerLabel.text = "\(timeLeft)"
            let greenColor = UIColor(hue: CGFloat(timeLeft) / 60, saturation: 1, brightness: 1, alpha: 1)
            progressLayer.strokeColor = greenColor.cgColor
        } else {
            timer?.invalidate()
        }
    }
    
    @objc func animateHeartBeat() {
            UIView.animate(withDuration: 0.5, animations: {
                //self.heartBeatLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            }) { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    //self.heartBeatLabel.transform = CGAffineTransform.identity
                })
            }
            
            /*heartBeatCount += 1
            heartBeatLabel.text = String(heartBeatCount)*/
            
            // Vibrate the phone in a heart beat manner
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    
    @objc func resetButtonTapped() {
        timer?.invalidate()
        //timer = nil
        timeLeft = Int.random(in: 30...80)
        timerLabel.text = "Time remaining: \(timeLeft)"
        startTimer()
    }
    
    //Private member funcs:
    private func setUpTitleView() {
        //Title object that is Rectangular and has the aforementioned dimensions and position
        let titleView = UIView(frame: CGRect(x:0, y:0, width: view.frame.size.width, height: 100)) //width property is assigned entire width of the page
        
        let label = UILabel(frame: CGRect(x:10, y:0, width: view.frame.size.width-40, height: 50))
        label.text = "Exercises"
        label.font = .systemFont(ofSize: 28, weight: .medium)
        titleView.addSubview(label) //adds smaller title (label) to overall title (not sure)
        
        
        navigationItem.titleView = titleView
    }
    private func setupSearchController() {
        let resultVC = SearchResultsViewController() //Create instance of searchviewcontroller //result view controller
        resultVC.delegate = self //self is current instance of UIViewController (like *this in cpp)
        //delegate is a member property of resultVC object type and is a protocol. (not sure)
        //so search controller is created which has input param that outputs onto search result view controller
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self //so whenever any value is typed, searcVC object which is the searchController's results is updated
        navigationItem.searchController = searchVC //created a navigation item object which is searchController and is assigned to searchVC which is the Apple actual implementation of a search controller, navigationItem just places it on page
    
    }
}
//extension/extra codespace thats in scope of watchlistviewcontroller class
extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, //so checks if query is equal to searchcontroller.searchBar.text which is text in searchBar and conditional also checks that query and trimming whitespace does not give empty word, thus query is an actual word, if not then return/end func
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController, //calls search controller and assigns output to searchResultsViewController
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        //Match these searches with a list of exercises that have custom rest times
        //Want to make search call which uses an API to connect app with a search directory
        APICaller.shared.search(query: query) { //takes in some input parameter query
            result in //completion handler is assigned result and is either .success or .failure
            switch result { //evaluates result handler
            case .success(let response): //if success, we initialize constant and print response to console
                print (response) //result is member func of response which is assigned to completion handler which is type SearchResponse which contains response array as member func
                DispatchQueue.main.async {
                    //Something that updates UI must be in main thread
                    //Update results controller of search bar with result of queries:
                    resultsVC.update(with: response.result) //error as result is object of type array with element type, but choose member variable symbol which is type string
                }

            case .failure(let error): //if failure, intiialize constant and print error to console
                print (error)
            }
        }
        
        
        
        //We want to update results controller after searching stuff, results controller shows the stuff below the search
        
        print(query) //output user input onto console (not app)
        //resultsVC is object that shows current table of results when searching so updating it with teh new set of results:
        //resultsVC.update(with: ["GOOG"])
    }
}
//Conforming class to protocol SearchResultsViewcontrollerDelegate
extension WatchListViewController: SearchResultsViewControllerDelegate {
    func SearchResultsViewControllerDidSelect(resultOut: SearchResult) { //must conform to protocol member func which includes SearchResults...DidSelect memberfunc
        print("Chosen something!")
    }
}

