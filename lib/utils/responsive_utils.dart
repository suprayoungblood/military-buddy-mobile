import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/services.dart';

/// A utility class that provides helper methods for responsive design in the app.
class ResponsiveUtils {
  // Private constructor to prevent instantiation
  ResponsiveUtils._();
  
  // Screen size reference (based on iPhone 13 - 390x844)
  static const double _referenceScreenWidth = 390.0;
  static const double _referenceScreenHeight = 844.0;
  
  // Device info cache
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double _safeBlockHorizontal;
  static late double _safeBlockVertical;
  static late EdgeInsets _padding;
  static late EdgeInsets _viewPadding;
  static late double _devicePixelRatio;
  static late double _statusBarHeight;
  static late double _bottomBarHeight;
  static late bool _isTablet;
  static late Orientation _orientation;
  static late DeviceType _deviceType;
  
  /// Initialize responsive utils with the BuildContext
  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;
    _padding = _mediaQueryData.padding;
    _viewPadding = _mediaQueryData.viewPadding;
    _devicePixelRatio = _mediaQueryData.devicePixelRatio;
    _statusBarHeight = _mediaQueryData.padding.top;
    _bottomBarHeight = _mediaQueryData.padding.bottom;
    _orientation = _mediaQueryData.orientation;
    
    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    _safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
    
    // Determine if tablet based on shortest side
    _isTablet = _mediaQueryData.size.shortestSide >= 600;
    
    // Determine device type
    _deviceType = _determineDeviceType();
  }
  
  /// Determines device type based on size and platform
  static DeviceType _determineDeviceType() {
    if (Platform.isIOS) {
      // iOS device detection
      if (_screenWidth > 1000 || _screenHeight > 1000) {
        return DeviceType.iosTablet;
      } else {
        return DeviceType.iosPhone;
      }
    } else if (Platform.isAndroid) {
      // Android device detection
      if (_screenWidth >= 600 || _screenHeight >= 600) {
        return DeviceType.androidTablet;
      } else {
        return DeviceType.androidPhone;
      }
    } else {
      // Default for other platforms
      return DeviceType.other;
    }
  }
  
  //
  // 1. SIZE ADAPTERS BASED ON SCREEN DIMENSIONS
  //
  
  /// Returns a responsive width based on screen size
  static double adaptiveWidth(double width) {
    return (width / _referenceScreenWidth) * _screenWidth;
  }
  
  /// Returns a responsive height based on screen size
  static double adaptiveHeight(double height) {
    return (height / _referenceScreenHeight) * _screenHeight;
  }
  
  /// Returns a responsive size based on screen size (for width and height)
  static double adaptiveSize(double size) {
    double widthFactor = _screenWidth / _referenceScreenWidth;
    double heightFactor = _screenHeight / _referenceScreenHeight;
    // Use the smaller factor to ensure the widget fits on screen
    return size * math.min(widthFactor, heightFactor);
  }
  
  /// Returns a responsive size as percentage of screen width
  static double widthPercent(double percent) {
    return _blockSizeHorizontal * percent;
  }
  
  /// Returns a responsive size as percentage of screen height
  static double heightPercent(double percent) {
    return _blockSizeVertical * percent;
  }
  
  /// Returns a responsive size as percentage of safe area width
  static double safeWidthPercent(double percent) {
    return _safeBlockHorizontal * percent;
  }
  
  /// Returns a responsive size as percentage of safe area height
  static double safeHeightPercent(double percent) {
    return _safeBlockVertical * percent;
  }
  
  //
  // 2. PLATFORM-SPECIFIC LAYOUT HELPERS
  //
  
  /// Returns true if the device is iOS
  static bool get isIOS => Platform.isIOS;
  
  /// Returns true if the device is Android
  static bool get isAndroid => Platform.isAndroid;
  
  /// Returns true if the device is a tablet
  static bool get isTablet => _isTablet;
  
  /// Returns true if the device is a phone
  static bool get isPhone => !_isTablet;
  
  /// Returns the current device type
  static DeviceType get deviceType => _deviceType;
  
  /// Returns true if the device is in landscape orientation
  static bool get isLandscape => _orientation == Orientation.landscape;
  
  /// Returns true if the device is in portrait orientation
  static bool get isPortrait => _orientation == Orientation.portrait;
  
  /// Returns a widget based on platform (iOS or Android)
  static Widget platformSpecificWidget({
    required Widget androidWidget,
    required Widget iosWidget,
  }) {
    return Platform.isIOS ? iosWidget : androidWidget;
  }
  
  /// Returns a value based on platform (iOS or Android)
  static T platformSpecificValue<T>({
    required T androidValue,
    required T iosValue,
  }) {
    return Platform.isIOS ? iosValue : androidValue;
  }
  
  /// Returns a device specific value based on device type
  static T deviceSpecificValue<T>({
    required T phoneValue,
    required T tabletValue,
  }) {
    return _isTablet ? tabletValue : phoneValue;
  }
  
  //
  // 3. RESPONSIVE TEXT SIZE CALCULATIONS
  //
  
  /// Returns a responsive text size based on screen size
  static double adaptiveTextSize(double size) {
    double scaleFactor = isTablet ? 1.15 : 1.0;
    return adaptiveSize(size) * scaleFactor;
  }
  
  /// Returns a responsive text style with adjusted size
  static TextStyle adaptiveTextStyle(TextStyle style, {double? size}) {
    double adaptedSize = size != null 
        ? adaptiveTextSize(size) 
        : adaptiveTextSize(style.fontSize ?? 14.0);
    
    return style.copyWith(fontSize: adaptedSize);
  }
  
  /// Returns a headline text size based on device type
  static double get headlineLargeSize => 
      adaptiveTextSize(isTablet ? 32.0 : 28.0);
      
  /// Returns a headline medium text size based on device type
  static double get headlineMediumSize => 
      adaptiveTextSize(isTablet ? 28.0 : 24.0);
      
  /// Returns a headline small text size based on device type
  static double get headlineSmallSize => 
      adaptiveTextSize(isTablet ? 24.0 : 20.0);
      
  /// Returns a body large text size based on device type
  static double get bodyLargeSize => 
      adaptiveTextSize(isTablet ? 18.0 : 16.0);
      
  /// Returns a body medium text size based on device type
  static double get bodyMediumSize => 
      adaptiveTextSize(isTablet ? 16.0 : 14.0);
      
  /// Returns a body small text size based on device type
  static double get bodySmallSize => 
      adaptiveTextSize(isTablet ? 14.0 : 12.0);
  
  //
  // 4. SAFE AREA INSETS MANAGEMENT
  //
  
  /// Returns the status bar height (top safe area)
  static double get statusBarHeight => _statusBarHeight;
  
  /// Returns the bottom bar height (bottom safe area)
  static double get bottomBarHeight => _bottomBarHeight;
  
  /// Returns the screen's safe area padding
  static EdgeInsets get padding => _padding;
  
  /// Returns the screen's view padding (including areas hidden by system UI)
  static EdgeInsets get viewPadding => _viewPadding;
  
  /// Returns safe area insets for different device models
  static EdgeInsets get safeAreaInsets {
    return EdgeInsets.only(
      top: _padding.top,
      bottom: _padding.bottom,
      left: _padding.left,
      right: _padding.right
    );
  }
  
  /// Returns safe area top padding
  static double get safeAreaTop => _padding.top;
  
  /// Returns safe area bottom padding
  static double get safeAreaBottom => _padding.bottom;
  
  /// Returns safe area left padding
  static double get safeAreaLeft => _padding.left;
  
  /// Returns safe area right padding
  static double get safeAreaRight => _padding.right;
  
  /// Applies safe area padding to the provided EdgeInsets
  static EdgeInsets applySafeArea(EdgeInsets padding) {
    return EdgeInsets.only(
      top: padding.top + safeAreaTop,
      bottom: padding.bottom + safeAreaBottom,
      left: padding.left + safeAreaLeft,
      right: padding.right + safeAreaRight,
    );
  }
  
  //
  // 5. DEVICE-SPECIFIC LAYOUT ADJUSTMENTS
  //
  
  /// Returns screen width
  static double get screenWidth => _screenWidth;
  
  /// Returns screen height
  static double get screenHeight => _screenHeight;
  
  /// Returns device pixel ratio
  static double get devicePixelRatio => _devicePixelRatio;
  
  /// Returns a widget sized based on device type
  static Widget sizedByDevice({
    required Widget child,
    required double phoneSize,
    required double tabletSize,
  }) {
    final size = _isTablet ? tabletSize : phoneSize;
    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }
  
  /// Returns a padding based on device type
  static EdgeInsets deviceAwarePadding({
    required EdgeInsets phonePadding,
    required EdgeInsets tabletPadding,
  }) {
    return _isTablet ? tabletPadding : phonePadding;
  }
  
  /// Returns a margin based on device type
  static EdgeInsets deviceAwareMargin({
    required EdgeInsets phoneMargin,
    required EdgeInsets tabletMargin,
  }) {
    return _isTablet ? tabletMargin : phoneMargin;
  }
  
  /// Returns a responsive grid layout configuration
  static int gridCrossAxisCount({
    required int phone,
    required int tablet,
  }) {
    return _isTablet ? tablet : phone;
  }
  
  /// Returns a responsive aspect ratio for grid items
  static double gridAspectRatio({
    required double phone,
    required double tablet,
  }) {
    return _isTablet ? tablet : phone;
  }
  
  /// Sets preferred orientations for the app
  static void setPreferredOrientations(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }
  
  /// Locks orientation to portrait mode only
  static void lockToPortrait() {
    setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  /// Locks orientation to landscape mode only
  static void lockToLandscape() {
    setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  
  /// Unlocks orientation to allow all modes
  static void unlockOrientation() {
    setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}

/// Enum representing different device types for more specific adjustments
enum DeviceType {
  iosPhone,
  iosTablet,
  androidPhone,
  androidTablet,
  other
}