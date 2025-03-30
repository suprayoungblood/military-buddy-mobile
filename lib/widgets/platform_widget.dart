import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/responsive_utils.dart';

/// A widget that renders differently based on the current platform.
///
/// This widget uses the [ResponsiveUtils] class to determine the platform and
/// provide the appropriate implementation (iOS or Android).
class PlatformWidget extends StatelessWidget {
  /// The widget to display on Android devices.
  final Widget androidBuilder;

  /// The widget to display on iOS devices.
  final Widget iosBuilder;

  /// Creates a platform-adaptive widget.
  ///
  /// Both [androidBuilder] and [iosBuilder] must not be null.
  const PlatformWidget({
    Key? key,
    required this.androidBuilder,
    required this.iosBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveUtils.platformSpecificWidget(
      androidWidget: androidBuilder,
      iosWidget: iosBuilder,
    );
  }
}

/// A widget that adapts to the current platform for basic components.
///
/// This widget provides implementations for common UI components that
/// follow platform-specific design guidelines.
class PlatformAdaptiveWidget extends StatelessWidget {
  /// The type of widget to be rendered.
  final PlatformWidgetType widgetType;

  /// Common widget properties.
  final String? title;
  final Widget? child;
  final VoidCallback? onPressed;
  final String? text;
  final IconData? icon;
  final Color? color;
  final bool? isDestructive;
  final bool? isEnabled;
  
  /// Creates a platform-adaptive widget of the specified type.
  ///
  /// The [widgetType] parameter is required. Other parameters depend on the
  /// widget type being created.
  const PlatformAdaptiveWidget({
    Key? key,
    required this.widgetType,
    this.title,
    this.child,
    this.onPressed,
    this.text,
    this.icon,
    this.color,
    this.isDestructive = false,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (widgetType) {
      case PlatformWidgetType.button:
        return _buildButton();
      case PlatformWidgetType.switch:
        return _buildSwitch();
      case PlatformWidgetType.dialog:
        return _buildDialog(context);
      case PlatformWidgetType.progressIndicator:
        return _buildProgressIndicator();
      case PlatformWidgetType.tabBar:
        return _buildTabBar();
      case PlatformWidgetType.appBar:
        return _buildAppBar();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildButton() {
    return PlatformWidget(
      androidBuilder: TextButton(
        onPressed: isEnabled! ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: isDestructive! ? Colors.red : color,
        ),
        child: Text(text ?? ''),
      ),
      iosBuilder: CupertinoButton(
        onPressed: isEnabled! ? onPressed : null,
        color: isDestructive! ? CupertinoColors.destructiveRed : color,
        child: Text(text ?? ''),
      ),
    );
  }

  Widget _buildSwitch() {
    final bool value = isEnabled ?? false;
    
    return PlatformWidget(
      androidBuilder: Switch(
        value: value,
        onChanged: (bool newValue) {
          if (onPressed != null) {
            onPressed!();
          }
        },
        activeColor: color,
      ),
      iosBuilder: CupertinoSwitch(
        value: value,
        onChanged: (bool newValue) {
          if (onPressed != null) {
            onPressed!();
          }
        },
        activeColor: color,
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    // This returns the widget that would be shown inside a showDialog call
    return PlatformWidget(
      androidBuilder: AlertDialog(
        title: title != null ? Text(title!) : null,
        content: child,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(text ?? 'OK'),
          ),
        ],
      ),
      iosBuilder: CupertinoAlertDialog(
        title: title != null ? Text(title!) : null,
        content: child,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            isDestructiveAction: false,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: onPressed,
            isDestructiveAction: isDestructive!,
            child: Text(text ?? 'OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return PlatformWidget(
      androidBuilder: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.blue),
      ),
      iosBuilder: CupertinoActivityIndicator(
        color: color,
      ),
    );
  }

  Widget _buildTabBar() {
    // This is a simplified tab bar - in a real implementation,
    // you would pass in tabs data and handle selection
    return PlatformWidget(
      androidBuilder: Container(
        color: color ?? Colors.blue,
        child: child,
      ),
      iosBuilder: CupertinoTabBar(
        backgroundColor: color,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return PlatformWidget(
      androidBuilder: AppBar(
        title: Text(title ?? ''),
        backgroundColor: color,
      ),
      iosBuilder: CupertinoNavigationBar(
        middle: Text(title ?? ''),
        backgroundColor: color,
      ),
    );
  }
}

/// Helper function to show a platform-specific dialog.
Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  String? confirmText,
  VoidCallback? onConfirm,
  bool isDestructive = false,
}) {
  if (ResponsiveUtils.isIOS) {
    return showCupertinoDialog<T>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: content,
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            isDestructiveAction: isDestructive,
            child: Text(confirmText ?? 'OK'),
          ),
        ],
      ),
    );
  } else {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onConfirm != null) onConfirm();
            },
            child: Text(confirmText ?? 'OK'),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// Types of platform-specific widgets that can be created.
enum PlatformWidgetType {
  button,
  switch,
  dialog,
  progressIndicator,
  tabBar,
  appBar,
}