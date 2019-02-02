//
//  CrowdinSDK.swift
//  CrowdinSDK
//
//  Created by Serhii Londar on 1/24/19.
//

import Foundation

@objc public class CrowdinSDK: NSObject {
	@objc public enum Mode: Int {
		case autoSDK
		case customSDK
		case autoBundle
		case customBundle
        
        var isAutoMode: Bool {
            return self == .autoSDK || self == .autoBundle
        }
        
        var isSDKMode: Bool {
            return self == .autoSDK || self == .customSDK
        }
	}
	
	@objc public class var mode: Mode {
		get {
			return Localization.current.mode
		}
		set {
			Localization.current.mode = newValue
		}
	}
	
	@objc public class var currentLocalization: String? {
		get {
			return Localization.current.currentLocalization
		}
		set {
			Localization.current.currentLocalization = currentLocalization
		}
	}
	
    public class var inSDKLocalizations: [String] { return Localization.current.inProvider }
    public class var inBundleLocalizations: [String] { return Localization.current.inBundle }
	
    public class func reloadUI() {
        UIUtil.shared.reload()
    }
    
    @objc public class func start(wirh provider: LocalizationProvider) {
        self.setProvider(provider)
        self.initializeLib()
    }
    
    public class func deintegrate() {
        Localization.current.provider.deintegrate()
    }
    
    public class func enableSDKLocalization(_ sdkLocalization: Bool, localization: String?) {
        if sdkLocalization {
            if localization != nil {
                self.mode = .customSDK
            } else {
                self.mode = .autoSDK
            }
        } else {
            if localization != nil {
                self.mode = .customBundle
            } else {
                self.mode = .autoBundle
            }
        }
        Localization.current.currentLocalization = localization
    }
    
    private class func initializeLib() {
		if self.mode == .customSDK || self.mode == .autoSDK {
			CrowdinSDK.swizzle()
		} else {
			CrowdinSDK.unswizzle()
		}
    }
	
    public class func setProvider(_ provider: LocalizationProvider) {
        Localization.current.provider = provider
        provider.setLocalization(currentLocalization)
        provider.localizationCompleted = self.localizationCompleted
    }
    
    public class var localizationCompleted: () -> Void {
        return {
            print("loaded")
            Localization.current.provider.setLocalization(currentLocalization)
            self.reloadUI()
        }
    }
    
}

extension CrowdinSDK {
    class func swizzle() {
        Bundle.swizzle()
        UILabel.swizzle()
        UIButton.swizzle()
    }
    
    class func unswizzle() {
        Bundle.unswizzle()
        UILabel.unswizzle()
        UIButton.unswizzle()
    }
}
