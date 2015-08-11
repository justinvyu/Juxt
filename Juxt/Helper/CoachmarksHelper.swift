//
//  CoachmarksHelper.swift
//  Juxt
//
//  Created by Justin Yu on 8/10/15.
//  Copyright (c) 2015 Justin Yu. All rights reserved.
//

import UIKit
import MPCoachMarks

class CoachmarksHelper: NSObject {
    
    
    // MARK: - Properties
    
    /// The type of dictionary that MPCoachMarks accepts as a valid coachmark.
    typealias mark = [String : NSObject]
    
    // MARK: - Keys
    /**
    An enum containing all the keys of the NSUserDefaults relating to coachmarks
    */
    enum keys: String {
        
        case Profile = "ProfileViewed"
        case AddJuxt = "AddJuxtViewed"
        case SeeDetail = "SeeDetailViewed"
        case AddPhoto = "AddPhotoViewed"
        case CompareUser = "CompareUserViewed"
        case Header = "HeaderViewed"
        case Share = "ShareViewed"
        case OverlayToggle = "OverlayToggleViewed"
        case SideBySide = "SideBySideViewed"
        case SaveToGallery = "SaveToGallery"
        case ShareToFacebook = "ShareToFacebook"
        
        static let allValues = [Profile, AddJuxt, SeeDetail, AddPhoto, Header, CompareUser, Share, OverlayToggle]
    }
    
    
    // MARK: - NSUserDefault Helper Methods
    
    /**
    Sets the NSUserDefault to true at given coach mark key.
    
    :param: coachmarkKey A value of type keys from Tutorial.keys which will be set to true in NSUserDefaults.
    */
    static func setCoachmarkHasBeenViewedToTrue(coachmarkKey: keys) {
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: coachmarkKey.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    /**
    Returns the value from NSUserDefaults for the coach mark key as a boolean.
    
    :param: coachmarkKey The string value of the coach mark NSUserDefault key from Tutorial.keys.
    
    :returns: The bool value of the NSUserDefault for the given coach mark key.
    */
    static func coachmarkHasBeenViewed(coachmarkKey: keys) -> Bool {
        
        return NSUserDefaults.standardUserDefaults().boolForKey(coachmarkKey.rawValue)
        
    }
    
    static func resetCoachmarksHaveBeenViewed() {
        
        for key in keys.allValues {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: key.rawValue)
        }
    }
    
    
    
    // MARK: - Creation Helper Methods
    
    /**
    Appends a new coachmark to an array of coachmarks by copying the array.
    
    :param: marks   The original list of coachmarks to be appended to.
    :param: newMark The coachmark to be appended to the original list of coachmarks.
    
    :returns: Returns a copy of the original coachmarks array with a new coachmark appended to it.
    */
    static func addMarkToCoachmarks(marks: [mark], newMark: mark) -> [mark] {
        
        // works because structs are passed by value, not reference
        var mutableMarks = marks
        mutableMarks.append(newMark)
        
        return mutableMarks
    }
    
    /**
    Create a coachmark dictionary from the necessary parameters.
    
    :param: rect      The position and size of the resulting coachmark.
    :param: caption   The caption to be shown with the coachmark.
    :param: shape     The shape of the highlighted area of the coachmark. Possible values are SHAPE_CIRCLE, SHAPE_SQUARE, and DEFAULT.
    :param: position  The position of the label relative to the coachmark. Possible values are LABEL_POSITION_BOTTOM, LABEL_POSITION_LEFT, LABEL_POSITION_TOP, LABEL_POSITION_RIGHT, and LABEL_POSITION_RIGHT_BOTTOM
    :param: alignment The alignment of the label relative to the coachmark. Possible values are LABEL_ALIGNMENT_CENTER, LABEL_ALIGNMENT_LEFT, and LABEL_ALIGNMENT_RIGHT.
    :param: showArrow The boolean value describing whether an arrow from the caption to the highlighted area will be shown.
    
    :returns: Returns a coachmark-format dictionary with the given values.
    */
    static func generateCoachmark(#rect: CGRect, caption: String, shape: MaskShape, position: LabelPosition, alignment: LabelAligment, showArrow: Bool) -> mark {
        
        
        return [
            "rect": NSValue(CGRect: rect),
            "caption": caption,
            "shape": NSNumber(integer: shape.rawValue),
            "position": NSNumber(integer: position.rawValue),
            "alignment": NSNumber(integer: alignment.rawValue),
            "showArrow": NSNumber(bool: showArrow)
        ]
    }
    
    
    /**
    Returns a coachmarks view to be added as a subview and later started.
    
    :param: coachmarks The array of coachmarks which will be shown by the coachmarks view.
    :param: withFrame  The frame of the returned coachmarks view. Defaults to UIScreen.mainScreen().bounds
    
    :returns: A new instance of MPCoachMarks generated with the given parameters.
    */
    static func generateCoachmarksViewWithMarks(marks coachmarks: [Dictionary<String, NSObject>], withFrame frame: CGRect) -> MPCoachMarks {
        
        return MPCoachMarks(frame: frame, coachMarks: coachmarks)
    }
}
