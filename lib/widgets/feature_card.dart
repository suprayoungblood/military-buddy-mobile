import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/responsive_utils.dart';
import 'dart:math' as math;

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool featured;
  final String? subtitle;
  
  const FeatureCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.featured = false,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utils
    ResponsiveUtils.init(context);
    
    // Use adaptive sizing based on device
    final double iconSize = ResponsiveUtils.adaptiveSize(featured ? 42 : 40);
    final double iconInnerSize = ResponsiveUtils.adaptiveSize(24);
    final double backgroundIconSize = ResponsiveUtils.adaptiveSize(80);
    final double borderRadius = ResponsiveUtils.isIOS ? 16.0 : 20.0;
    
    // Use adaptive text sizes
    final double titleSize = ResponsiveUtils.adaptiveTextSize(15);
    final double subtitleSize = ResponsiveUtils.adaptiveTextSize(12);
    final double ctaSize = ResponsiveUtils.adaptiveTextSize(14);
    
    // Apply platform-specific shadow
    final BoxShadow shadow = BoxShadow(
      color: color.withOpacity(featured ? 0.2 : 0.1),
      blurRadius: ResponsiveUtils.isIOS ? 6 : 8,
      offset: Offset(0, ResponsiveUtils.isIOS ? 3 : 4),
      spreadRadius: ResponsiveUtils.isIOS ? 0 : 1,
    );
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [shadow],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: featured ? color : Colors.white,
          child: InkWell(
            onTap: onTap,
            splashColor: color.withOpacity(0.1),
            highlightColor: color.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveUtils.adaptiveSize(10.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: featured ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(ResponsiveUtils.isIOS ? 12 : 16),
                        ),
                        child: Center(
                          child: Icon(
                            icon,
                            color: featured ? Colors.white : color,
                            size: iconInnerSize,
                          ),
                        ),
                      ),
                      if (featured)
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Icon(
                              Icons.send,
                              color: Colors.white.withOpacity(0.2),
                              size: backgroundIconSize,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.adaptiveSize(8)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: featured ? Colors.white : MilitaryTheme.navy,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: ResponsiveUtils.adaptiveSize(2)),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: featured ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (featured) ...[
                    SizedBox(height: ResponsiveUtils.adaptiveSize(8)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: ctaSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.adaptiveSize(4)),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: ResponsiveUtils.adaptiveSize(14),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}