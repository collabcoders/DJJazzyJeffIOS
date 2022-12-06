import UIKit
 // TODO [🌶]: duplication
public struct InstaLayerAnimatorGradientConfiguration: LayerAnimatorGradientConfigurable {
    
    public private(set) var animationDuration: CFTimeInterval = 2
    public private(set) var fromColor: CGColor = UIColor(red: 0.027, green: 0.075, blue: 0.173, alpha: 0.5).cgColor
    public private(set) var toColor: CGColor = UIColor(red: 112, green: 112, blue: 112).cgColor
}


