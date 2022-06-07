//
//  UIHelper.swift
//  TaleTree
//
//  Created by UFL on 16/12/20.
//  Copyright © 2020 UnfoldLabs. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    func changeTextFieldBorder()
    {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
}

extension UIButton
{
    func changeButtonCornerRadius()
    {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
    
}

@IBDesignable
class PlaceHolderTextView: UITextView {
    
    @IBInspectable var placeholder: String = "" {
        didSet{
            updatePlaceHolder()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor = UIColor.gray {
        didSet {
            updatePlaceHolder()
        }
    }
    
    private var originalTextColor = UIColor.darkText
    private var originalText: String = ""
    
    private func updatePlaceHolder() {
        
        if self.text == "" || self.text == placeholder  {
            
            self.text = placeholder
            self.textColor = placeholderColor
            if let color = self.textColor {
                
                self.originalTextColor = color
            }
            self.originalText = ""
        } else {
            self.textColor = self.originalTextColor
            self.originalText = self.text
        }
        
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.text = self.originalText
        self.textColor = self.originalTextColor
        return result
    }
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updatePlaceHolder()
        
        return result
    }
}



@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
extension UIView {
    func displayViewShadow()
    {
        let radius: CGFloat = self.frame.width / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.05 * radius, height: self.frame.height))
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5.0 
        self.layer.masksToBounds =  false
        self.layer.shadowPath = shadowPath.cgPath
    }
    
}

public class UIHelper: NSObject {
    
    let visibleKey = "visibleKey"
    
    static let shared = UIHelper()
    
    func setTutorialVisiblity(flag: Bool) {
        UserDefaults.standard.set(flag, forKey: visibleKey)
        UserDefaults.standard.synchronize()
    }
    
    func isVisible() -> Bool? {
        let flag = UserDefaults.standard.value(forKey: visibleKey)
        if let flag = flag as? Bool {
            return flag
        }
        return true
    }
    
    class func isEqualArray(first array1: [AnyHashable], second array2: [AnyHashable]) -> Bool {
        
        let set1: Set<AnyHashable>
        let set2: Set<AnyHashable>
        
        if array1.count > array2.count {
            set1 = Set(array1)
            set2 = Set(array2)
        } else {
            set1 = Set(array2)
            set2 = Set(array1)
        }
        return set2.isSubset(of: set1)
    }
    
    class func getAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        return appVersion
    }
    
    class func getUUID() -> String {
        
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
        
    }
    
    class func getDeviceName() ->String{
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return "iOS"
    }
    class func getOSVersion() ->String{
        return UIDevice.current.systemVersion
        
    }
    
    class func getRAMSize() ->UInt64{
        return ProcessInfo.processInfo.physicalMemory
        
    }
    
}

@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
extension UITextField {
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0.9096479024)
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UIColor{
    
    func getColor()
    {
        
    }
}

extension String
    
{
    
    func isValidEmail1() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let regex = "^[A-z ]+$"
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return stringTest.evaluate(with: self)
    }
    
    func isValidPhoneNo() -> Bool {
        
        let regex = "([+]?1+[-]?)?+([(]?+([0-9]{3})?+[)]?)?+[-]?+[0-9]{3}+[-]?+[0-9]{4}"
        let stringTest = NSPredicate(format:"SELF MATCHES %@", regex)
        return stringTest.evaluate(with: self)
    }
    
    func getStringFromPhoneNumber() -> String{
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }
    func getPhoneNumberFromString() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1)$2-$3", options: .regularExpression, range: nil)
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

extension UIViewController{
    
    
    func showAlert(title:String,msg:String)
    {
        
        //Displaying alert with multiple actions and custom font ans size
        //   let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let alertController = UIAlertController(title:title , message: msg, preferredStyle: .alert)
        
        let titFont = [NSAttributedString.Key.font: UIFont(name: "System", size: 18.0)]
        let msgFont = [NSAttributedString.Key.font: UIFont(name: "System", size: 15.0)]
        
        let titAttrString = NSMutableAttributedString(string: title, attributes: titFont)
        let msgAttrString = NSMutableAttributedString(string: msg, attributes: msgFont)
        
        alertController.setValue(titAttrString, forKey: "attributedTitle")
        alertController.setValue(msgAttrString, forKey: "attributedMessage")
        //  alertController.view.tintColor = UIColor.blue
        alertController.view.layer.cornerRadius = 40
        
        self.present(alertController, animated: true, completion: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alertController.addAction(okAction)
        
    }
    
    func changeFontForViewController(){
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Bold", size: 17)!]
        
    }
    
    
    func showAlertView(title:String,msg:String)
    {
        
        let alertController = UIAlertController(title:title , message: msg, preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        
        alertController.addAction(okAction)
        
    }
    
}


extension CAGradientLayer {
    
    enum Point {
        case topRight, topLeft
        case bottomRight, bottomLeft
        case custion(point: CGPoint)
        
        var point: CGPoint {
            switch self {
            case .topRight: return CGPoint(x: 1, y: 0)
            case .topLeft: return CGPoint(x: 0, y: 0)
            case .bottomRight: return CGPoint(x: 1, y: 1)
            case .bottomLeft: return CGPoint(x: 0, y: 1)
            case .custion(let point): return point
            }
        }
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(frame: CGRect, colors: [UIColor], startPoint: Point, endPoint: Point) {
        self.init(frame: frame, colors: colors, startPoint: startPoint.point, endPoint: endPoint.point)
    }
    
    func createGradientImage() -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
extension UINavigationBar {
    func setGradientBackground(colors: [UIColor], startPoint: CAGradientLayer.Point = .topLeft, endPoint: CAGradientLayer.Point = .bottomLeft) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors, startPoint: startPoint, endPoint: endPoint)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

@IBDesignable
class TooltipView1: UIView {
    
    //MARK: - IBInspectable
    
    @IBInspectable var arrowTopLeft: Bool = false
    @IBInspectable var arrowTopCenter: Bool = true
    @IBInspectable var arrowTopRight: Bool = false
    @IBInspectable var arrowBottomLeft: Bool = false
    @IBInspectable var arrowBottomCenter: Bool = false
    @IBInspectable var arrowBottomRight: Bool = false
    
    @IBInspectable var fillColor: UIColor = UIColor.white
    
    @IBInspectable var borderColor1: UIColor = UIColor.blue
    @IBInspectable var borderRadius: CGFloat = 0
    @IBInspectable var borderWidth1: CGFloat = 0
    
    @IBInspectable var shadowColor1: UIColor = UIColor.white
    @IBInspectable var shadowOffsetX: CGFloat = 0
    @IBInspectable var shadowOffsetY: CGFloat = 0
    @IBInspectable var shadowBlur: CGFloat = 10
    
    //MARK: - Global Variables
    
    var tooltipWidth = 0
    var tooltipHeight = 0
    
    //MARK: - Initialization
    
    override func draw(_ rect: CGRect) {
        drawTooltip()
    }
    
    //MARK: - Private Methods
    
    // Orientation methods
    
    private func topLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func topRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: y)
    }
    
    private func bottomLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: CGFloat(tooltipHeight) - y)
    }
    
    private func bottomRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: CGFloat(tooltipHeight) - y)
    }
    
    // Draw methods
    
    private func drawTooltip() {
        
        tooltipWidth = Int(bounds.width)
        tooltipHeight = Int(bounds.height)
        
        // Define Bubble Shape
        
        let bubblePath = UIBezierPath()
        
        // Top left corner
        
        bubblePath.move(to: topLeft(0, borderRadius))
        bubblePath.addCurve(to: topLeft(borderRadius, 0), controlPoint1: topLeft(0, borderRadius / 2), controlPoint2: topLeft(borderRadius / 2, 0))
        
        // Top right corner
        
        bubblePath.addLine(to: topRight(borderRadius, 0))
        bubblePath.addCurve(to: topRight(0, borderRadius), controlPoint1: topRight(borderRadius / 2, 0), controlPoint2: topRight(0, borderRadius / 2))
        
        // Bottom right corner
        
        bubblePath.addLine(to: bottomRight(0, borderRadius))
        bubblePath.addCurve(to: bottomRight(borderRadius, 0), controlPoint1: bottomRight(0, borderRadius / 2), controlPoint2: bottomRight(borderRadius / 2, 0))
        
        // Bottom left corner
        
        bubblePath.addLine(to: bottomLeft(borderRadius, 0))
        bubblePath.addCurve(to: bottomLeft(0, borderRadius), controlPoint1: bottomLeft(borderRadius / 2, 0), controlPoint2: bottomLeft(0, borderRadius / 2))
        bubblePath.close()
        
        // Arrow
        
        if(arrowTopLeft) {
            bubblePath.move(to: topLeft(90, 80))
            bubblePath.addLine(to: topLeft(80, -4))
            bubblePath.addLine(to: topLeft(96, 2))
            bubblePath.close()
        }
        
        if(arrowTopCenter) {
            bubblePath.move(to: topLeft(CGFloat((tooltipWidth / 2) - 5), 0))
            bubblePath.addLine(to: topLeft(CGFloat(tooltipWidth / 2), -8))
            bubblePath.addLine(to: topLeft(CGFloat(tooltipWidth / 2 + 5), 0))
            bubblePath.close()
        }
        
        if(arrowTopRight) {
            bubblePath.move(to: topRight(16, 2))
            bubblePath.addLine(to: topRight(3, -4))
            bubblePath.addLine(to: topRight(3, 10))
            bubblePath.close()
        }
        
        if(arrowBottomLeft) {
            bubblePath.move(to: bottomLeft(16, 2))
            bubblePath.addLine(to: bottomLeft(3, -4))
            bubblePath.addLine(to: bottomLeft(3, 10))
            bubblePath.close()
        }
        
        if(arrowBottomCenter) {
            bubblePath.move(to: bottomLeft(CGFloat((tooltipWidth / 2) - 5), 0))
            bubblePath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2), -8))
            bubblePath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2 + 5), 0))
            bubblePath.close()
        }
        
        if(arrowBottomRight) {
            bubblePath.move(to: bottomRight(3, 10))
            bubblePath.addLine(to: bottomRight(3, -4))
            bubblePath.addLine(to: bottomRight(16, 2))
            bubblePath.close()
        }
        
        // Shadow Layer
        
        let shadowShape = CAShapeLayer()
        shadowShape.path = bubblePath.cgPath
        shadowShape.fillColor = fillColor.cgColor
        shadowShape.shadowColor = shadowColor1.cgColor
        shadowShape.shadowOffset = CGSize(width: CGFloat(shadowOffsetX), height: CGFloat(shadowOffsetY))
        shadowShape.shadowRadius = CGFloat(shadowBlur)
        shadowShape.shadowOpacity = 0.9
        
        // Border Layer
        
        let borderShape = CAShapeLayer()
        borderShape.path = bubblePath.cgPath
        borderShape.fillColor = fillColor.cgColor
        borderShape.strokeColor = borderColor1.cgColor
        borderShape.lineWidth = CGFloat(borderWidth1*2)
        
        // Fill Layer
        
        let fillShape = CAShapeLayer()
        fillShape.path = bubblePath.cgPath
        fillShape.fillColor = fillColor.cgColor
        
        // Add Sublayers
        
        self.layer.insertSublayer(shadowShape, at: 0)
        self.layer.insertSublayer(borderShape, at: 0)
        self.layer.insertSublayer(fillShape, at: 0)
        
    }
    
}

@IBDesignable
class TooltipView: UIView {
    
    //MARK: - IBInspectable
    
    @IBInspectable var arrowTopLeft: Bool = false
    @IBInspectable var arrowTopCenter: Bool = true
    @IBInspectable var arrowTopRight: Bool = false
    @IBInspectable var arrowBottomLeft: Bool = false
    @IBInspectable var arrowBottomCenter: Bool = false
    @IBInspectable var arrowBottomRight: Bool = false
    
    @IBInspectable var fillColor: UIColor = UIColor.white
    
    @IBInspectable var borderColor1: UIColor = UIColor.blue
    @IBInspectable var borderRadius: CGFloat = 18
    @IBInspectable var borderWidth1: CGFloat = 1
    
    @IBInspectable var shadowColor1: UIColor = UIColor.white
    @IBInspectable var shadowOffsetX: CGFloat = 0
    @IBInspectable var shadowOffsetY: CGFloat = 2
    @IBInspectable var shadowBlur: CGFloat = 10
    
    //MARK: - Global Variables
    
    var tooltipWidth = 0
    var tooltipHeight = 0
    
    //MARK: - Initialization
    
    override func draw(_ rect: CGRect) {
        drawTooltip()
    }
    
    //MARK: - Private Methods
    
    // Orientation methods
    
    private func topLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    private func topRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: y)
    }
    
    private func bottomLeft(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: CGFloat(tooltipHeight) - y)
    }
    
    private func bottomRight(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(tooltipWidth) - x, y: CGFloat(tooltipHeight) - y)
    }
    
    // Draw methods
    
    private func drawTooltip() {
        
        tooltipWidth = Int(bounds.width)
        tooltipHeight = Int(bounds.height)
        
        // Define Bubble Shape
        
        let bubblePath = UIBezierPath()
        
        // Top left corner
        
        bubblePath.move(to: topLeft(0, borderRadius))
        bubblePath.addCurve(to: topLeft(borderRadius, 0), controlPoint1: topLeft(0, borderRadius / 2), controlPoint2: topLeft(borderRadius / 2, 0))
        
        // Top right corner
        
        bubblePath.addLine(to: topRight(borderRadius, 0))
        bubblePath.addCurve(to: topRight(0, borderRadius), controlPoint1: topRight(borderRadius / 2, 0), controlPoint2: topRight(0, borderRadius / 2))
        
        // Bottom right corner
        
        bubblePath.addLine(to: bottomRight(0, borderRadius))
        bubblePath.addCurve(to: bottomRight(borderRadius, 0), controlPoint1: bottomRight(0, borderRadius / 2), controlPoint2: bottomRight(borderRadius / 2, 0))
        
        // Bottom left corner
        
        bubblePath.addLine(to: bottomLeft(borderRadius, 0))
        bubblePath.addCurve(to: bottomLeft(0, borderRadius), controlPoint1: bottomLeft(borderRadius / 2, 0), controlPoint2: bottomLeft(0, borderRadius / 2))
        bubblePath.close()
        
        // Arrow
        
        if(arrowTopLeft) {
            bubblePath.move(to: topLeft(90, 80))
            bubblePath.addLine(to: topLeft(80, -4))
            bubblePath.addLine(to: topLeft(96, 2))
            bubblePath.close()
        }
        
        if(arrowTopCenter) {
            bubblePath.move(to: topLeft(CGFloat((tooltipWidth / 2) - 5), 0))
            bubblePath.addLine(to: topLeft(CGFloat(tooltipWidth / 2), -8))
            bubblePath.addLine(to: topLeft(CGFloat(tooltipWidth / 2 + 5), 0))
            bubblePath.close()
        }
        
        if(arrowTopRight) {
            bubblePath.move(to: topRight(16, 2))
            bubblePath.addLine(to: topRight(3, -4))
            bubblePath.addLine(to: topRight(3, 10))
            bubblePath.close()
        }
        
        if(arrowBottomLeft) {
            bubblePath.move(to: bottomLeft(16, 2))
            bubblePath.addLine(to: bottomLeft(3, -4))
            bubblePath.addLine(to: bottomLeft(3, 10))
            bubblePath.close()
        }
        
        if(arrowBottomCenter) {
            bubblePath.move(to: bottomLeft(CGFloat((tooltipWidth / 2) - 5), 0))
            bubblePath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2), -8))
            bubblePath.addLine(to: bottomLeft(CGFloat(tooltipWidth / 2 + 5), 0))
            bubblePath.close()
        }
        
        if(arrowBottomRight) {
            bubblePath.move(to: bottomRight(3, 10))
            bubblePath.addLine(to: bottomRight(3, -4))
            bubblePath.addLine(to: bottomRight(16, 2))
            bubblePath.close()
        }
        
        // Shadow Layer
        
        let shadowShape = CAShapeLayer()
        shadowShape.path = bubblePath.cgPath
        shadowShape.fillColor = fillColor.cgColor
        shadowShape.shadowColor = shadowColor1.cgColor
        shadowShape.shadowOffset = CGSize(width: CGFloat(shadowOffsetX), height: CGFloat(shadowOffsetY))
        shadowShape.shadowRadius = CGFloat(shadowBlur)
        shadowShape.shadowOpacity = 0.8
        
        // Border Layer
        
        let borderShape = CAShapeLayer()
        borderShape.path = bubblePath.cgPath
        borderShape.fillColor = fillColor.cgColor
        borderShape.strokeColor = borderColor1.cgColor
        borderShape.lineWidth = CGFloat(borderWidth1*2)
        
        // Fill Layer
        
        let fillShape = CAShapeLayer()
        fillShape.path = bubblePath.cgPath
        fillShape.fillColor = fillColor.cgColor
        
        // Add Sublayers
        
        self.layer.insertSublayer(shadowShape, at: 0)
        self.layer.insertSublayer(borderShape, at: 0)
        self.layer.insertSublayer(fillShape, at: 0)
        
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

class UIRoundedImageView: UIImageView {
    
    @IBInspectable var isRoundedCorners: Bool = false {
        didSet { setNeedsLayout() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isRoundedCorners {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = UIBezierPath(ovalIn:
                CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height
            )).cgPath
            layer.mask = shapeLayer
        }
        else {
            layer.mask = nil
        }
        
    }
    
}
extension String {
    
    /// Handles 10 or 11 digit phone numbers
    ///
    /// - Returns: formatted phone number or original value
    public func toPhoneNumber() -> String {
        let digits = self.digitsOnly
        if digits.count == 10 {
            return digits.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1)$2-$3", options: .regularExpression, range: nil)
        }
        else if digits.count == 11 {
            return digits.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d+)", with: "$1($2)-$3-$4", options: .regularExpression, range: nil)
        }
        else {
            return self
        }
    }
    
}

extension StringProtocol {
    
    /// Returns the string with only [0-9], all other characters are filtered out
    var digitsOnly: String {
        return String(filter(("0"..."9").contains))
    }
    
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}




