
import UIKit

class GaugeView: UIView {
    // outer and inner Bezels
    let outerBezelColor = UIColor(displayP3Red: 0, green: 0.5, blue: 1, alpha: 1)
    let outerBezelWidth : CGFloat = 10
    let innerBezelColor = UIColor.white
    let innerBezelWidth: CGFloat = 5
    let insideColor = UIColor.white
    //segments
    var segmentWidth: CGFloat = 20
    var segmentColors = [UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1), UIColor(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(displayP3Red: 0, green: 0.5, blue: 0, alpha: 1), UIColor(displayP3Red: 0.7, green: 0, blue: 0, alpha: 1)]
    var totalAngle: CGFloat = 270
    var rotation: CGFloat = -135
    
    // major and minor ticks
    var majorTickColor = UIColor.black
    var majorTickWidth: CGFloat = 2
    var majorTickLength: CGFloat = 25
    var minorTickColor = UIColor.black.withAlphaComponent(0.5)
    var minorTickWidth: CGFloat = 1
    var minorTickLength: CGFloat = 20
    var minorTickCount = 4
    
    // disc
    var outerCenterDiscColor = UIColor.init(white: 0.9, alpha: 1)
    var outerCenterDiscWidth: CGFloat = 40
    var innerCenterDiscColor = UIColor.init(white: 0.7, alpha: 1)
    var innerCenterDiscWidth: CGFloat = 25
    
    //needle
    var needleWidth: CGFloat = 4
    var needleColor = UIColor.init(white: 0.7, alpha: 1)
    let needle = UIView()
    
    //label
    let valueLabel = UILabel()
    var labelFont = UIFont.systemFont(ofSize: 50)
    var labelColor = UIColor.black
    
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        drawBackground(in: rect, context: ctx)
        drawSegment(in: rect, context: ctx)
        drawTick(in: rect, context: ctx)
        drawCenterDisc(in: rect, context: ctx)
    }
    
    
    func drawBackground(in rect: CGRect, context ctx: CGContext){
        outerBezelColor.set()
        ctx.fillEllipse(in: rect)
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        innerBezelColor.set()
        ctx.fillEllipse(in: innerBezelRect)
        let insideRect = innerBezelRect.insetBy(dx: innerBezelWidth, dy: innerBezelWidth)
        insideColor.set()
        ctx.fillEllipse(in: insideRect)
        
    }
    
    
    func drawSegment(in rect: CGRect, context ctx: CGContext){
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation ) - .pi/2)
        ctx.setLineWidth(segmentWidth)
        let segmentAngle = deg2rad(totalAngle/CGFloat(segmentColors.count))
        let segmentRadius = rect.width/2 - outerBezelWidth - innerBezelWidth - segmentWidth/2
        for (index, segmentColor) in segmentColors.enumerated(){
            let startAngle = CGFloat(index) * segmentAngle
            segmentColor.set()
            ctx.addArc(center: .zero, radius: segmentRadius, startAngle: startAngle, endAngle: startAngle + segmentAngle, clockwise: false)
            ctx.drawPath(using: .stroke)
        }
        ctx.restoreGState()
    }
    func deg2rad(_ degree: CGFloat) -> CGFloat{
        return degree * .pi/180
    }
    
    func drawTick(in rect: CGRect, context ctx: CGContext){
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        ctx.rotate(by: deg2rad(rotation) - .pi/2)
        let segmentAngle = deg2rad(totalAngle/CGFloat(segmentColors.count))
        let segmentRadius = rect.width/2 - outerBezelWidth - innerBezelWidth - segmentWidth/2
        // minor Tick
        ctx.saveGState()
        ctx.setLineWidth(minorTickWidth)
        minorTickColor.set()
        let minorTickAngle = segmentAngle / CGFloat(minorTickCount + 1)
        let minorEnd = segmentRadius + segmentWidth/2
        let minorStart = minorEnd - minorTickLength
        for _ in 0..<segmentColors.count{
            ctx.rotate(by: minorTickAngle)
            for _ in 0..<minorTickCount{
                ctx.move(to: CGPoint(x: minorStart, y: 0))
                ctx.addLine(to: CGPoint(x: minorEnd, y: 0))
                ctx.drawPath(using: .stroke)
                ctx.rotate(by: minorTickAngle)
            }
        }

        ctx.restoreGState()
        //major Tick
        ctx.saveGState()
        ctx.setLineWidth(majorTickWidth)
        majorTickColor.set()
        let majorEnd = segmentRadius + segmentWidth/2
        let majorStart = majorEnd - majorTickLength
        for _ in 0...segmentColors.count{
            ctx.move(to: CGPoint(x: majorStart, y: 0))
            ctx.addLine(to: CGPoint(x: majorEnd, y: 0))
            ctx.drawPath(using: .stroke)
            ctx.rotate(by: segmentAngle)
        }
        ctx.restoreGState()

        ctx.restoreGState()
    }
    
    func drawCenterDisc(in rect: CGRect, context ctx: CGContext){
        ctx.saveGState()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        
        let outerRect = CGRect(x: -outerCenterDiscWidth/2 , y: -outerCenterDiscWidth/2, width: outerCenterDiscWidth, height: outerCenterDiscWidth)
        outerCenterDiscColor.set()
        ctx.fillEllipse(in: outerRect)
        
        let innerRect = CGRect(x: -innerCenterDiscWidth/2 , y: -innerCenterDiscWidth/2, width: innerCenterDiscWidth, height: innerCenterDiscWidth)
        innerCenterDiscColor.set()
        ctx.fillEllipse(in: innerRect)
        
    }
    
    func setup(){
        // needle
        needle.backgroundColor = needleColor
        needle.translatesAutoresizingMaskIntoConstraints = false
        needle.bounds = CGRect(x: 0, y: 0, width: needleWidth, height: bounds.height/3)
        needle.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        needle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        addSubview(needle)
        
        //label
        valueLabel.font = labelFont
        valueLabel.textColor = labelColor
        valueLabel.text = "100"
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            ])
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    var value: Int = 0 {
        didSet {
            valueLabel.text = String(value)
            let needlePosition = CGFloat(value) / 100
            let lerpFrom = rotation
            let lerpTo = rotation + totalAngle
            let needleRotation = lerpFrom + (lerpTo - lerpFrom) * needlePosition
            needle.transform = CGAffineTransform(rotationAngle: deg2rad(needleRotation))
        }
    }
}
