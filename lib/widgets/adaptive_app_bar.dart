import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import '../utils/theme.dart';

/// A platform-adaptive app bar widget that automatically uses AppBar on Android
/// and CupertinoNavigationBar on iOS, with proper handling of safe area insets.
///
/// This widget supports:
/// - Automatic platform detection
/// - Leading and trailing widgets
/// - Title and subtitle display
/// - Branch-specific theming
/// - Animations for transitions
class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title of the app bar
  final String title;
  
  /// Optional subtitle displayed below the title
  final String? subtitle;
  
  /// Optional leading widget (typically a back button)
  final Widget? leading;
  
  /// Optional list of trailing widgets (typically action buttons)
  final List<Widget>? trailing;
  
  /// Background color of the app bar
  final Color? backgroundColor;
  
  /// Foreground/text color of the app bar
  final Color? foregroundColor;
  
  /// Whether this app bar should impart padding appropriate for the top of the screen
  final bool applySafeArea;
  
  /// Military branch ID for branch-specific theming
  final String? branchId;
  
  /// Controls whether the app bar should automatically add a back button when possible
  final bool automaticallyImplyLeading;
  
  /// Controls the elevation/shadow of the app bar (Android only)
  final double elevation;
  
  /// Controls whether titles should be centered (Android only)
  final bool centerTitle;
  
  /// Specifies a gradient background instead of a solid color (Android only)
  final Gradient? gradient;
  
  /// Custom transition animation duration
  final Duration transitionDuration;
  
  /// Callback when the back button is pressed
  final VoidCallback? onBackPressed;

  const AdaptiveAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.applySafeArea = true,
    this.branchId,
    this.automaticallyImplyLeading = true,
    this.elevation = 0.0,
    this.centerTitle = true,
    this.gradient,
    this.transitionDuration = const Duration(milliseconds: 200),
    this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize {
    // Return platform-specific preferred size for proper layout
    return Size.fromHeight(Platform.isIOS 
        ? subtitle != null ? 70.0 : 44.0  // iOS nav bar has fixed height
        : subtitle != null ? 70.0 : 56.0  // Android app bar standard height
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get branch-specific colors and configuration
    final (bgColor, fgColor, branchGradient) = _getBranchTheme();
    
    return Platform.isIOS 
        ? _buildCupertinoNavigationBar(context, bgColor, fgColor, branchGradient)
        : _buildMaterialAppBar(context, bgColor, fgColor, branchGradient);
  }

  /// Builds the iOS-specific navigation bar
  Widget _buildCupertinoNavigationBar(
    BuildContext context, 
    Color bgColor, 
    Color fgColor,
    Gradient? branchGradient
  ) {
    // For iOS we need to handle safe area manually for gradient backgrounds
    if (branchGradient != null) {
      return CupertinoNavigationBar(
        middle: _buildTitle(true, fgColor),
        leading: _buildLeadingWidget(context, true, fgColor),
        trailing: trailing != null ? Row(
          mainAxisSize: MainAxisSize.min,
          children: trailing!,
        ) : null,
        backgroundColor: Colors.transparent,
        border: null, // Remove the default border
      );
    }
    
    // Standard implementation with solid color
    return CupertinoNavigationBar(
      middle: _buildTitle(true, fgColor),
      leading: _buildLeadingWidget(context, true, fgColor),
      trailing: trailing != null ? Row(
        mainAxisSize: MainAxisSize.min,
        children: trailing!,
      ) : null,
      backgroundColor: bgColor.withOpacity(0.9), // iOS navbar typically has blur
      border: subtitle != null
          ? null // Remove border when we have a subtitle for custom implementation
          : const Border(
              bottom: BorderSide(
                color: CupertinoColors.separator,
                width: 0.0,
              ),
            ),
    );
  }

  /// Builds the Android-specific app bar
  Widget _buildMaterialAppBar(
    BuildContext context, 
    Color bgColor, 
    Color fgColor,
    Gradient? branchGradient
  ) {
    // Use a container with gradient if specified
    if (branchGradient != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: branchGradient,
        ),
        child: AppBar(
          title: _buildTitle(false, fgColor),
          leading: _buildLeadingWidget(context, false, fgColor),
          actions: trailing,
          backgroundColor: Colors.transparent,
          foregroundColor: fgColor,
          elevation: elevation,
          centerTitle: centerTitle,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: _isDarkColor(bgColor) 
                ? Brightness.light 
                : Brightness.dark,
          ),
        ),
      );
    }
    
    // Standard implementation with solid color
    return AppBar(
      title: _buildTitle(false, fgColor),
      leading: _buildLeadingWidget(context, false, fgColor),
      actions: trailing,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: elevation,
      centerTitle: centerTitle,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkColor(bgColor) 
            ? Brightness.light 
            : Brightness.dark,
      ),
    );
  }

  /// Builds the title widget, which may include a subtitle
  Widget _buildTitle(bool isIOS, Color fgColor) {
    if (subtitle == null) {
      return Text(
        title,
        style: TextStyle(
          color: fgColor,
          fontSize: isIOS ? 17.0 : 20.0,
          fontWeight: FontWeight.w600,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }
    
    // Title with subtitle layout
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: fgColor,
            fontSize: isIOS ? 17.0 : 18.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle!,
          style: TextStyle(
            color: fgColor.withOpacity(0.7),
            fontSize: isIOS ? 14.0 : 14.0,
            fontWeight: FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Builds the leading widget (typically a back button)
  Widget? _buildLeadingWidget(BuildContext context, bool isIOS, Color fgColor) {
    // If a custom leading widget is provided, use it
    if (leading != null) return leading;
    
    // If we're not automatically implying a leading widget, return null
    if (!automaticallyImplyLeading) return null;
    
    // Check if we need to show a back button
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    
    if (canPop) {
      return isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.back,
                    color: fgColor,
                    size: 24,
                  ),
                ],
              ),
            )
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              color: fgColor,
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            );
    }
    
    return null;
  }

  /// Determines if a color is "dark" for proper contrast with text
  bool _isDarkColor(Color color) {
    // Calculate luminance, formula to determine if text should be white or black
    return color.computeLuminance() < 0.5;
  }

  /// Gets the appropriate theme colors and gradient based on branch ID
  (Color, Color, Gradient?) _getBranchTheme() {
    Color bgColor = backgroundColor ?? MilitaryTheme.navy;
    Color fgColor = foregroundColor ?? Colors.white;
    Gradient? branchGradient = gradient;
    
    // Apply branch-specific colors if a branch ID is provided
    if (branchId != null) {
      switch (branchId) {
        case 'army':
          bgColor = MilitaryTheme.army;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.armyGradient;
          break;
        case 'navy':
          bgColor = MilitaryTheme.navyBlue;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.navyGradient;
          break;
        case 'marines':
          bgColor = MilitaryTheme.marines;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.marinesGradient;
          break;
        case 'airforce':
          bgColor = MilitaryTheme.airForce;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.airForceGradient;
          break;
        case 'coastguard':
          bgColor = MilitaryTheme.coastGuard;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.coastGuardGradient;
          break;
        case 'spaceforce':
          bgColor = MilitaryTheme.spaceForce;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.spaceForceGradient;
          break;
        default:
          bgColor = MilitaryTheme.navy;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.navyGradient;
      }
    }
    
    return (bgColor, fgColor, branchGradient);
  }
}

/// A version of the adaptive app bar that includes a gradient background with a parallax scroll effect.
/// 
/// This extends the functionality of AdaptiveAppBar to create a more visually engaging app bar
/// that responds to scroll input.
class AdaptiveParallaxAppBar extends StatelessWidget {
  /// The title for the app bar
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// The expanded height of the app bar when fully visible
  final double expandedHeight;
  
  /// Whether the app bar is pinned (stays visible when scrolling)
  final bool pinned;
  
  /// Whether the app bar is floating (can reappear when scrolling back)
  final bool floating;
  
  /// Background color of the app bar
  final Color? backgroundColor;
  
  /// Foreground/text color of the app bar
  final Color? foregroundColor;
  
  /// Optional leading widget
  final Widget? leading;
  
  /// Optional trailing/action widgets
  final List<Widget>? actions;
  
  /// Optional background image for the parallax effect
  final Widget? backgroundImage;
  
  /// Military branch ID for branch-specific theming
  final String? branchId;
  
  /// Optional gradient background
  final Gradient? gradient;
  
  /// Callback for when the back button is pressed
  final VoidCallback? onBackPressed;

  const AdaptiveParallaxAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.expandedHeight = 200.0,
    this.pinned = true,
    this.floating = false,
    this.backgroundColor,
    this.foregroundColor,
    this.leading,
    this.actions,
    this.backgroundImage,
    this.branchId,
    this.gradient,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get branch-specific colors and configuration
    final (bgColor, fgColor, branchGradient) = _getBranchTheme();
    
    // iOS devices use a different implementation
    if (Platform.isIOS) {
      return _buildCupertinoSliverAppBar(context, bgColor, fgColor, branchGradient);
    }
    
    // Android uses material design components
    return _buildMaterialSliverAppBar(context, bgColor, fgColor, branchGradient);
  }

  /// Builds the iOS-specific sliver app bar
  Widget _buildCupertinoSliverAppBar(
    BuildContext context, 
    Color bgColor, 
    Color fgColor,
    Gradient? branchGradient
  ) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      backgroundColor: Colors.transparent,
      foregroundColor: fgColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: leading ?? (ModalRoute.of(context)?.canPop == true 
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(
                CupertinoIcons.back,
                color: fgColor,
              ),
            )
          : null),
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: fgColor,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: branchGradient ?? gradient,
            color: branchGradient == null && gradient == null ? bgColor : null,
          ),
          child: Stack(
            children: [
              if (backgroundImage != null)
                Positioned.fill(child: backgroundImage!),
              
              // Optional overlay gradient for better text visibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Android-specific sliver app bar
  Widget _buildMaterialSliverAppBar(
    BuildContext context, 
    Color bgColor, 
    Color fgColor,
    Gradient? branchGradient
  ) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      backgroundColor: Colors.transparent,
      foregroundColor: fgColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: leading ?? (ModalRoute.of(context)?.canPop == true 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (onBackPressed != null) {
                  onBackPressed!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          : null),
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        title: subtitle != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: fgColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: fgColor.withOpacity(0.8),
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              )
            : Text(
                title,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
        background: Container(
          decoration: BoxDecoration(
            gradient: branchGradient ?? gradient,
            color: branchGradient == null && gradient == null ? bgColor : null,
          ),
          child: Stack(
            children: [
              if (backgroundImage != null)
                Positioned.fill(child: backgroundImage!),
              
              // Optional overlay gradient for better text visibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the appropriate theme colors and gradient based on branch ID
  (Color, Color, Gradient?) _getBranchTheme() {
    Color bgColor = backgroundColor ?? MilitaryTheme.navy;
    Color fgColor = foregroundColor ?? Colors.white;
    Gradient? branchGradient = gradient;
    
    // Apply branch-specific colors if a branch ID is provided
    if (branchId != null) {
      switch (branchId) {
        case 'army':
          bgColor = MilitaryTheme.army;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.armyGradient;
          break;
        case 'navy':
          bgColor = MilitaryTheme.navyBlue;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.navyGradient;
          break;
        case 'marines':
          bgColor = MilitaryTheme.marines;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.marinesGradient;
          break;
        case 'airforce':
          bgColor = MilitaryTheme.airForce;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.airForceGradient;
          break;
        case 'coastguard':
          bgColor = MilitaryTheme.coastGuard;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.coastGuardGradient;
          break;
        case 'spaceforce':
          bgColor = MilitaryTheme.spaceForce;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.spaceForceGradient;
          break;
        default:
          bgColor = MilitaryTheme.navy;
          fgColor = Colors.white;
          branchGradient = MilitaryTheme.navyGradient;
      }
    }
    
    return (bgColor, fgColor, branchGradient);
  }
}