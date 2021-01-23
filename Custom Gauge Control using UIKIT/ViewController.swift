
import UIKit

class ViewController: UIViewController {

    @IBOutlet var slider: UISlider!
    var gaugeView: GaugeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gaugeView = GaugeView(frame: CGRect(x: 40, y: 40, width: 256, height: 256))
        gaugeView.backgroundColor = .clear
        view.addSubview(gaugeView)
    }

    @IBAction func sliderChanged(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.05) {
                self?.gaugeView.value = Int(self?.slider.value ?? 0)
            }
        }
    }


}

