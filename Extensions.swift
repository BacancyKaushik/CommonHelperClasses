//
//  Extensions.swift
//  IRAFinancial
//
//  Created by Jayesh Thummar on 12/05/22.
//

import Foundation
import UIKit
import CommonCrypto


enum AIEdge:Int
{
    case
    Top,
    Left,
    Bottom,
    Right,
    Top_Left,
    Top_Right,
    Bottom_Left,
    Bottom_Right,
    All,
    None
}

extension UIApplication
{
    /// Sweeter: Returns the currently top-most view controller.
   public var currentWindow: UIWindow?
    {
        connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    }
    
    public class func topViewController(base: UIViewController? = UIApplication.shared.currentWindow?.rootViewController) -> UIViewController?
    {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }

    /// Sweeter: Show `viewController` over the top-most view controller.
    public class func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            topViewController()?.present(viewController, animated: animated, completion: completion)
        }
    }
}

extension Bundle
{
    var appVersion: String?
    {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var mainAppVersion: String?
    {
        Bundle.main.appVersion
    }
}

//MARK: - Array index out of bound
extension Collection
{
    subscript (safe index: Index) -> Element?
    {
        return indices.contains(index) ? self[index] : nil
    }
}

//MARK: - UITextField
extension UITextField
{
    func bottomBorder(color: UIColor = .white)
    {
        let border = CALayer()
            let borderWidth = CGFloat(1.0)
            border.borderColor = color.cgColor
            border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
            border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
    }
    
    public func isValidPassword(text: String) -> Bool
    {
        //`~!@#$%^&*()-_=+[{]};:'",<.>/?
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%>#*<?\\[\\]:/,\"&=;_}{'.()+`~^-])[A-Za-z\\d$@$!%>#*<?\\[\\]:/,\"&=;_}{'.()+`~^-]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: text)
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        }
        catch
        {
            return false
        }
    }
    
    func setLeftRightPaddingPoints(_ amount:CGFloat, txt:  UITextField, radius : Int, borderColor : UIColor, borderWidth : CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        self.rightView = paddingView
        self.rightViewMode = .always
        
        txt.layer.borderColor = borderColor.cgColor
        txt.layer.borderWidth = borderWidth
        txt.layer.cornerRadius = CGFloat(radius)
    }
}

enum RegEx: String
{
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password1 = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}" // Password length 8-15
    case password = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"//"^[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{8,}$"
    case alphabeticStringWithSpace = "^[a-zA-Z ]*$" // e.g. hello sandeep
    case alphabeticStringFirstLetterCaps = "^[A-Z]+[a-zA-Z]*$" // SandsHell
    case phoneNo = "[0-9]{10}" // PhoneNo 10 Digits
    case zipCode = "^[A-Z0-9a-z].{4,9}" // zipcode 4 to 8 digits
   
    
    //Change RegEx according to your Requirement
}




extension UIView
{
    func setCornerRadius(radius: CGFloat)
    {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    //MARK:- HEIGHT / WIDTH

    var width:CGFloat {
        return self.frame.size.width
    }
    var height:CGFloat {
        return self.frame.size.height
    }
    var xPos:CGFloat {
        return self.frame.origin.x
    }
    var yPos:CGFloat {
        return self.frame.origin.y
    }

    //MARK:- DASHED BORDER
    func drawDashedBorderAroundView()
    {
        let cornerRadius: CGFloat = self.frame.size.width / 2
        let borderWidth: CGFloat = 0.5
        let dashPattern1: Int = 4
        let dashPattern2: Int = 2
        let lineColor = UIColor.white

        //drawing
        let frame: CGRect = self.bounds
        let shapeLayer = CAShapeLayer()
        //creating a path
        let path: CGMutablePath = CGMutablePath()

        //drawing a border around a view
        path.move(to: CGPoint(x: CGFloat(0), y: CGFloat(frame.size.height - cornerRadius)), transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(0), y: CGFloat(cornerRadius)), transform: .identity)
        path.addArc(center: CGPoint(x: CGFloat(cornerRadius), y: CGFloat(cornerRadius)), radius: CGFloat(cornerRadius), startAngle: CGFloat(Double.pi), endAngle: CGFloat(-Double.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(frame.size.width - cornerRadius), y: CGFloat(0)), transform: .identity)
        path.addArc(center: CGPoint(x: CGFloat(frame.size.width - cornerRadius), y: CGFloat(cornerRadius)), radius: CGFloat(cornerRadius), startAngle: CGFloat(-Double.pi / 2), endAngle: CGFloat(0), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(frame.size.width), y: CGFloat(frame.size.height - cornerRadius)), transform: .identity)
        path.addArc(center: CGPoint(x: CGFloat(frame.size.width - cornerRadius), y: CGFloat(frame.size.height - cornerRadius)), radius: CGFloat(cornerRadius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi / 2), clockwise: false, transform: .identity)
        path.addLine(to: CGPoint(x: CGFloat(cornerRadius), y: CGFloat(frame.size.height)), transform: .identity)
        path.addArc(center: CGPoint(x: CGFloat(cornerRadius), y: CGFloat(frame.size.height - cornerRadius)), radius: CGFloat(cornerRadius), startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: false, transform: .identity)

        //path is set as the _shapeLayer object's path

        shapeLayer.path = path
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.frame = frame
        shapeLayer.masksToBounds = false
        shapeLayer.setValue(NSNumber(value: false), forKey: "isCircle")
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineDashPattern = [NSNumber(integerLiteral: dashPattern1),NSNumber(integerLiteral: dashPattern2)]
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        self.layer.addSublayer(shapeLayer)
        //self.layer.cornerRadius = cornerRadius
    }


    //MARK:- ROTATE
    func rotate(angle: CGFloat)
    {
        let radians = angle / 180.0 * CGFloat(Double.pi)
        self.transform = self.transform.rotated(by: radians);
    }




    //MARK:- BORDER
    func applyBorderDefault( color: UIColor)
    {
        self.applyBorder(color: color, width: 1.0)
    }
    
    func applyBorderDefault1( color: UIColor)
    {
        self.applyBorder(color: color, width: 1.0)
    }
    
    func applyBorderDefault2( color: UIColor)
    {
        self.applyBorder(color: color, width: 1.0)
    }
    
    func applyBorder(color:UIColor, width:CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }


    //MARK:- CIRCLE
    func applyCircle()
    {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) * 0.5
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    func applyCircleWithRadius(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    //MARK:- CORNER RADIUS
    func applyCornerRadius(radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    func applyCornerRadiusDefault()
    {
        self.applyCornerRadius(radius: 5.0)
    }


    //MARK:- SHADOW
    func applyShadowDefault( color: UIColor)
    {
        self.applyShadowWithColor(color: color, opacity: 0.5, radius: 1)
    }

    func applyShadowWithColor(color:UIColor)
    {
        self.applyShadowWithColor(color: color, opacity: 0.5, radius: 1)
    }

    func applyShadowWithColor(color:UIColor, opacity:Float, radius: CGFloat)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }



    func applyShadowWithColor(color:UIColor, opacity:Float, radius: CGFloat, edge:AIEdge, shadowSpace:CGFloat)
    {

        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace) //CGSizeMake(0, -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0) //CGSizeMake(-shadowSpace, 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace) //CGSizeMake(0, shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0) //CGSizeMake(shadowSpace, 0)


        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace) //CGSizeMake(-shadowSpace, -shadowSpace )
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace) //CGSizeMake(shadowSpace, -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace) //CGSizeMake(-shadowSpace, shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace) //CGSizeMake(shadowSpace, shadowSpace)


        case .All:
            sizeOffset = CGSize(width: 0, height: 0) //CGSizeMake(0, 0)
        case .None:
            sizeOffset = CGSize.zero
        }

        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }


    func addBorderWithColor(color:UIColor, edge:AIEdge, thicknessOfBorder:CGFloat)
    {

        // dispatch_async(dispatch_get_main_queue()) {

        DispatchQueue.main.async {

            var rect:CGRect = CGRect.zero

            switch edge {
            case .Top:
                rect = CGRect(x: 0, y: 0, width: self.width, height: thicknessOfBorder) //CGRectMake(0, 0, self.width, thicknessOfBorder);
            case .Left:
                rect = CGRect(x: 0, y: 0, width: thicknessOfBorder, height:self.width ) //CGRectMake(0, 0, thicknessOfBorder, self.height);
            case .Bottom:
                rect = CGRect(x: 0, y: self.height - thicknessOfBorder, width: self.width, height: thicknessOfBorder) //CGRectMake(0, self.height - thicknessOfBorder, self.width, thicknessOfBorder);
            case .Right:
                rect = CGRect(x: self.width-thicknessOfBorder, y: 0, width: thicknessOfBorder, height: self.height) //CGRectMake(self.width-thicknessOfBorder, 0,thicknessOfBorder, self.height);
            default:
                break
            }

            let layerBorder = CALayer()
            layerBorder.frame = rect
            layerBorder.backgroundColor = color.cgColor
            self.layer.addSublayer(layerBorder)
        }
    }


    func animateVibrate()
    {

        let duration = 0.05

        UIView.animate(withDuration: duration ,
                                   animations: {
                                    self.transform = self.transform.translatedBy(x: 5, y: 0)
        },
                                   completion: { finish in

                                    UIView.animate(withDuration: duration ,
                                                               animations: {
                                                                self.transform = self.transform.translatedBy(x: -10, y: 0)
                                    },
                                                               completion: { finish in


                                                                UIView.animate(withDuration: duration ,
                                                                                           animations: {
                                                                                            self.transform = self.transform.translatedBy(x: 10, y: 0)
                                                                },
                                                                                           completion: { finish in


                                                                                            UIView.animate(withDuration: duration ,
                                                                                                                       animations: {
                                                                                                                        self.transform = self.transform.translatedBy(x: -10, y: 0)
                                                                                            },
                                                                                                                       completion: { finish in

                                                                                                                        UIView.animate(withDuration: duration){
                                                                                                                            self.transform = CGAffineTransform.identity
                                                                                                                        }
                                                                                            })
                                                                })
                                    })
        })
    }
}

extension Data
{
    func urlSafeBase64EncodedString() -> String
    {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    public func sha256() -> String
    {
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData
    {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String
    {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes
        {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

struct Header: Encodable
{
    let alg = "RS256"//"HS256"
    let typ = "JWT"
}



extension RangeReplaceableCollection where Self: StringProtocol
{
    mutating func replaceOccurrences<Target: StringProtocol, Replacement: StringProtocol>(of target: Target, with replacement: Replacement, options: String.CompareOptions = [], range searchRange: Range<String.Index>? = nil) {
        self = .init(replacingOccurrences(of: target, with: replacement, options: options, range: searchRange))
    }
}

//MARK: - UICOLOR
extension UIColor
{

    class var customGreen: UIColor
    {
        let darkGreen = 0x008110
        return UIColor.rgb(fromHex: darkGreen)
    }

    class func rgb(fromHex: Int) -> UIColor
    {

        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Int
{
    func toDouble() -> Double
    {
        Double(self)
    }
    
    func toPrice(currency: String) -> String
    {
            let nf = NumberFormatter()
            nf.decimalSeparator = ","
            nf.groupingSeparator = "."
            nf.groupingSize = 3
            nf.usesGroupingSeparator = true
            nf.minimumFractionDigits = 2
            nf.maximumFractionDigits = 2
            return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
        }
}

extension Double
{
    func toInt() -> Int
    {
        Int(self)
    }
}
