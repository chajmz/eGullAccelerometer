//
//  ViewController.swift
//  eGull
//
//  Created by Guillaume Pabia on 21/01/2016.
//  Copyright © 2016 Guillaume Pabia. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController , UITableViewDataSource {


  var arrayValue : [String] = [String]()
  var motionManager: CMMotionManager = CMMotionManager()


  @IBOutlet weak var xLabel: UILabel!
  @IBOutlet weak var yLabel: UILabel!
  @IBOutlet weak var zLabel: UILabel!


  @IBOutlet weak var tableView: UITableView!

  func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    // Tableview stuff
    tableView.dataSource = self
    self.view.addSubview(tableView)
    tableView.estimatedRowHeight = 89
    tableView.rowHeight = UITableViewAutomaticDimension

    /* 1/x for x values per second */
    motionManager.accelerometerUpdateInterval = 1/50
    motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in

      let xValue = String(format: "%.3f", accelerometerData!.acceleration.x)
      let yValue = String(format: "%.3f", accelerometerData!.acceleration.y)
      let zValue = String(format: "%.3f", accelerometerData!.acceleration.z)

      self.xLabel.text = xValue
      self.yLabel.text = yValue
      self.zLabel.text = zValue

      let valueString = " X : \(xValue)  Y : \(yValue) Z : \(zValue)"
      self.arrayValue.insert(valueString, atIndex: 0)
        if(self.arrayValue.count > 500){
          self.arrayValue.removeAtIndex(500)
        }

      // Delay the reloading of the tableView to prevent freeze when scrolling and at the beginning
      self.delay(2) {
        self.tableView.reloadData()
      }
    }

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }



  //TableView stuff 

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrayValue.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.textLabel?.text = arrayValue[indexPath.row]
    return cell
  }

}

