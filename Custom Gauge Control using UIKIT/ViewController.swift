
import UIKit

class ViewController: UIViewController {

    @IBOutlet var slider: UISlider!
    var gaugeView: GaugeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        gaugeView = GaugeView(frame: CGRect(x: view.bounds.width/2 - 128, y: view.bounds.height/2 - 128, width: 256, height: 256))
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

