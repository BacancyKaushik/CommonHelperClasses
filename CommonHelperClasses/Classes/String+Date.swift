//
//  String+Date.swift
//  SampleProject
//
//  Created by Bharat Kakadiya on 30/12/19.
//  Copyright © 2019 Bharat Kakadiya. All rights reserved.
//

import UIKit

enum DateFormate: String
{
    case yyyy_MM_dd_HH_MM_SS_Z = "yyyy-MM-dd HH:mm:ss Z"
    case yyyy_MM_dd_T_HH_MM_SS_Z = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case dd_MM_yyyy_hh_mm_a = "dd/MM/yyyy hh:mm a"
    case dd_MMM_yyyy = "dd-MMM-yyyy"
    
    case hh_mm_a = "hh:mm a"
    case hh_mm_A = "hh:mm A"
    case MM_dd_yyyy_hh_mm_a = "MM/dd/yyyy hh:mm a"
    case yyyy_MM_dd = "yyyy-MM-dd"
    case MM_dd_yyyy = "MM/dd/yyyy"
    case dd_MM_yyyy = "dd/MM/yyyy"
    case yyyy_MM_dd_hh_mm_a = "yyyy-MM-dd hh:mm a"

    
    case yy = "yy"
    case MM = "MM"
    case MM_DD = "MMM dd"
}

extension String
{
    //Convert timezone string to NSTimeZone
    func toDate(format: DateFormate = .yyyy_MM_dd_T_HH_MM_SS_Z, timZone: TimeZone? = TimeZone(abbreviation: "UTC")) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if format == .yyyy_MM_dd_T_HH_MM_SS_Z
        {
            if let formattedDate = dateFormatter.date(from: self)
            {
                return formattedDate
            }
            else
            {
                dateFormatter.dateFormat = DateFormate.yyyy_MM_dd_T_HH_MM_SS_Z.rawValue
                return dateFormatter.date(from: self)
            }
        }
        return dateFormatter.date(from: self)
    }
    
    //change date to UTC time zone
    func changeDateFormateToUTC(fromFormat: DateFormate = .yyyy_MM_dd_T_HH_MM_SS_Z, toFormat: DateFormate = .dd_MMM_yyyy) -> String?
    {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = fromFormat.rawValue
        dateformatter.calendar = Calendar.current
        dateformatter.timeZone = TimeZone.current
        
        if let date = dateformatter.date(from: self)
        {
            dateformatter.timeZone = TimeZone(abbreviation: "UTC")
            dateformatter.dateFormat = toFormat.rawValue
            
            print("dtDate = \(date)")
            
            let strDate = dateformatter.string(from: date)
            print("dt = \(strDate)")
            
            return strDate
        }
        
        return ""
    }
    
    func changeDateFormate(fromFormat: DateFormate = .yyyy_MM_dd_T_HH_MM_SS_Z, toFormat: DateFormate = .dd_MMM_yyyy) -> String?
    {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = fromFormat.rawValue
        inputFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        
        if let showDate = inputFormatter.date(from: self)
        {
            inputFormatter.dateFormat = toFormat.rawValue
            
            if fromFormat.rawValue .contains("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                inputFormatter.timeZone = TimeZone.ReferenceType.local
            }
            else
            {
                inputFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone?
            }
            
            //inputFormatter.locale = Locale.current
            let resultString = inputFormatter.string(from: showDate)
            return resultString
        }
        return ""
    }
    
    func convertToNextDate(dateFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
    
    func convertToYesterDate(dateFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isNullorEmpty() -> Bool
    {
        if self.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
        {
            return false
        }
        return true
    }
    
    func removeExraSpaces() -> String
    {
        return self.replacingOccurrences(of: "  ", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    func removeNonNumericCharacters() -> String
    {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func removeNonNumericCharactersExceptDot() -> String
    {
        return self.filter("0123456789.".contains)
    }
    
    var asURL: URL?
    {
        URL(string: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
}

extension Date
{
    func toString(formateType type: DateFormate) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
        return (startDate.compare(self) == .orderedAscending || startDate.compare(self) == .orderedSame) && (endDate.compare(self) == .orderedDescending || endDate.compare(self) == .orderedSame)
    }
    
    func dayNameOfWeek() -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func dayNameOfWeekThreeLetters() -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> Date
    {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
 
    func getDiferenceInDays(endDate: Date) -> Int?
    {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        return components.day
    }
}
