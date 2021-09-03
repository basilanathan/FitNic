//
//  CLTimer.swift
//  Pods
//
//  Created by apple on 05/07/16.
//
//

import UIKit

@objc public protocol cltimerDelegate {
     func timerDidUpdate(time:Int)
     func timerDidStop(time:Int)
}


public class CLTimer: UIView {
    
    
   public enum timeFormat{
        case Minutes
        case Seconds
    }

   public enum timerMode{
        case Reverse
        case Forward
    }
    
    public weak var cltimer_delegate :   cltimerDelegate?
   public  var showDefaultCountDown    =   true {
        didSet{
            setNeedsDisplay()
        }
    }
    var text    =   NSMutableAttributedString()
    var countDownFormat =   0
    var countDownFontSize   =   CGFloat()
    var timeModeForward =   Bool()
    var schedular   =   Timer()
    var countDownSchedular   =   Timer()
    var timerSeconds    =   Int()
    var remainingTime   =   0
    var countdownScalar =   0
    var countdownSmoother   =   0.01
    var coveredTime:Double   =   0
    var timeValue = "5Min"
    var isRunning   =   false
    @IBInspectable
    var timerBackgroundColor  :    UIColor =   UIColor.lightGray{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var countDownColor   :    UIColor =   UIColor.green{
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    var timerRadius :   CGFloat {
        return min(bounds.size.width,bounds.size.height)/2 * 0.80
    }
    
    var timerCenter :   CGPoint {
        return CGPoint(x: bounds.midX,y: bounds.midY)
    }
    
    
    
    
    
    
    
    override public func draw(_ rect: CGRect) {
        
        let timer   =   pathForTimer(centerPoint: timerCenter, radius: timerRadius)
        
        UIColor.clear.setFill()
        timerBackgroundColor.setStroke()
        timer.fill()
        timer.stroke()
        
        
        let countDown   =   pathForCountdown(centerPoint: timerCenter, radius: timerRadius)
        UIColor.clear.setFill()
        countDownColor.setStroke()
        countDown.fill()
        countDown.stroke()
        
        
        
        
        if showDefaultCountDown{
            
        
       
        if countDownFormat==0{
             text = NSMutableAttributedString(string: timeValue)
             countDownFontSize   =   (timerRadius/CGFloat(text.length)) * 2
        }else if countDownFormat==1{
             let currentTime = secondsToMinutes(timeToConvert: remainingTime)
            text = NSMutableAttributedString(string: "\(currentTime.min)"+":"+"\(currentTime.sec)")
            countDownFontSize   =   (timerRadius/CGFloat(text.length)) * 2.5
        }
       
        
        
        text.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: countDownFontSize), range: NSMakeRange(0, text.length))
        text.addAttribute(NSForegroundColorAttributeName,value: countDownColor, range: NSMakeRange(0, text.length))
        text.draw(at: CGPoint(x: timerCenter.x-text.size().width/2,y: timerCenter.y-text.size().height/2))

        }
    }
    
    func secondsToMinutes(timeToConvert:Int)->(min:Int,sec:Int){
        return (timeToConvert/60,timeToConvert%60)
    }
    
    
    private func pathForTimer(centerPoint:CGPoint,radius:CGFloat)->UIBezierPath{
       
        let path    =   UIBezierPath(arcCenter:centerPoint ,
                                     radius: radius,
                                     startAngle: 0.0,
                                     endAngle: CGFloat(2*Double.pi),
                                     clockwise: false)
        
        
        
        path.lineWidth  =   5.0
        return path
        
    }
    
    private func pathForCountdown(centerPoint:CGPoint,radius:CGFloat)->UIBezierPath{
        
        var startAngle  =   CGFloat()
        var endAngle    =   CGFloat()
        
        if timeModeForward{
            
            if coveredTime <= 0.0{
                coveredTime =   0.0
            }else{
                
            }

            endAngle   =   CGFloat((2*Double.pi)/Double(timerSeconds))*CGFloat(coveredTime)
            startAngle  =   CGFloat((3*Double.pi)/Double(2.0))
            
            
            let path    =   UIBezierPath(arcCenter:centerPoint ,radius: radius,startAngle: startAngle,endAngle: startAngle+endAngle,clockwise: true)
            path.lineWidth  =   10.0
            return path
            
        }else{
            startAngle   =   CGFloat((2*Double.pi)/Double(timerSeconds))*CGFloat(coveredTime)
            endAngle  =   CGFloat((3*Double.pi)/Double(2.0))
            
            let path    =   UIBezierPath(arcCenter:centerPoint ,radius: radius,startAngle: (startAngle + endAngle),endAngle: endAngle,clockwise: false)
            path.lineWidth  =   15.0
            return path
        }
        
    }
    
    
    
    
    public func updateText(timeValue:String){
        self.timeValue = timeValue
        
        text = NSMutableAttributedString(string: timeValue)
        countDownFontSize   =   (timerRadius/CGFloat(text.length)) * 2
        
        text.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: countDownFontSize), range: NSMakeRange(0, text.length))
        text.addAttribute(NSForegroundColorAttributeName,value: countDownColor, range: NSMakeRange(0, text.length))
        text.draw(at: CGPoint(x: timerCenter.x-text.size().width/2,y: timerCenter.y-text.size().height/2))


    }

    
  public  func startTimer(withSeconds seconds:Int,format:timeFormat,mode:timerMode){
        resetVariables()
        timerSeconds    =   seconds
    
    
    switch format{
    case .Seconds:
        countDownFormat=0
    case .Minutes:
        countDownFormat=1
    }
    
    switch mode{
    case .Forward:
        timeModeForward =   true
    case .Reverse:
        remainingTime   =   seconds
        coveredTime =  Double(seconds)
        timeModeForward =   false
    }
    
        schedular  =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CLTimer.updateTimer), userInfo: nil, repeats: true)
        
        countDownSchedular =   Timer.scheduledTimer(timeInterval: countdownSmoother, target: self, selector: #selector(CLTimer.updateCountDownTimer), userInfo: nil, repeats: true)
        
        
    }
    
    
    func updateTimer(){
        
        if timeModeForward{
             remainingTime    =   remainingTime    +   1
            
            if remainingTime ==  timerSeconds    {
                schedular.invalidate()
                
            }
            
        }else{
             remainingTime    =   remainingTime    -   1
            
            if remainingTime ==  0    {
                schedular.invalidate()
                
            }
        }
        
        cltimer_delegate?.timerDidUpdate(time: remainingTime)
       setNeedsDisplay()
        

    }
    
  public  func resetTimer(){
        countDownSchedular.invalidate()
        schedular.invalidate()
        remainingTime=0
        schedular  =  Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(CLTimer.setToStart), userInfo: nil, repeats: true)
    }
   
  public  func stopTimer(){
    cltimer_delegate?.timerDidStop(time: remainingTime)
        countDownSchedular.invalidate()
        schedular.invalidate()
    }
    
    func setToStart(){
        
        if timeModeForward{
            coveredTime =   coveredTime -  coveredTime*100
            if coveredTime  <= 0.0{
                print("ccc",coveredTime)
                schedular.invalidate()
                 setNeedsDisplay()
            }else{
                setNeedsDisplay()
            }
            
        }else{
            coveredTime =   coveredTime +  (Double(timerSeconds)-coveredTime)*10
            
            if coveredTime  >= Double(timerSeconds){
                schedular.invalidate()
                setNeedsDisplay()
            }else{
                setNeedsDisplay()
            }
            
            
        }
        
       
       
        
    }
    
    
    func updateCountDownTimer(){
        
        if timeModeForward{
            coveredTime =   coveredTime +   countdownSmoother
            if coveredTime >= Double(timerSeconds){
                countDownSchedular.invalidate()
            }else{
                setNeedsDisplay()
            }
            
            
        }else{
            coveredTime =   coveredTime -   countdownSmoother*2.30
            if coveredTime  <= 0 {
                countDownSchedular.invalidate()
            }else{
              setNeedsDisplay()  
            }
        }
        
    }
    
    
    func resetVariables(){
         countDownFormat =   0
         remainingTime   =   0
         countdownScalar =   0
         countdownSmoother   =   0.01
         coveredTime   =   0
        countDownSchedular.invalidate()
        schedular.invalidate()
    }
    
    
    
    
}
