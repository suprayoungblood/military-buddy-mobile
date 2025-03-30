import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BranchSelector extends StatefulWidget {
  final Function(String) onBranchSelected;
  
  const BranchSelector({
    Key? key,
    required this.onBranchSelected,
  }) : super(key: key);

  @override
  State<BranchSelector> createState() => _BranchSelectorState();
}

class _BranchSelectorState extends State<BranchSelector> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _selectedBranch;
  
  final List<Map<String, dynamic>> _branches = [
    {
      'name': 'Army',
      'image': 'assets/images/Military_Logos/Army_Seal.png',
      'color': MilitaryTheme.army,
      'gradient': MilitaryTheme.armyGradient,
    },
    {
      'name': 'Navy',
      'image': 'assets/images/Military_Logos/Navy_Seal.png',
      'color': MilitaryTheme.navyBlue,
      'gradient': MilitaryTheme.navyGradient,
    },
    {
      'name': 'Marines',
      'image': 'assets/images/Military_Logos/Marines_Seal.png',
      'color': MilitaryTheme.marines,
      'gradient': MilitaryTheme.marinesGradient,
    },
    {
      'name': 'Air Force',
      'image': 'assets/images/Military_Logos/Airforce_Seal.png',
      'color': MilitaryTheme.airForce,
      'gradient': MilitaryTheme.airForceGradient,
    },
    {
      'name': 'Space Force',
      'image': 'assets/images/Military_Logos/SpaceForce_Seal.png',
      'color': MilitaryTheme.spaceForce,
      'gradient': MilitaryTheme.spaceForceGradient,
    },
    {
      'name': 'Coast Guard',
      'image': 'assets/images/Military_Logos/CoastGuard_Seal.png',
      'color': MilitaryTheme.coastGuard,
      'gradient': MilitaryTheme.coastGuardGradient,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Select a Branch',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MilitaryTheme.navy,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _branches.length,
            itemBuilder: (context, index) {
              final branch = _branches[index];
              final isSelected = _selectedBranch == branch['name'];
              
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedBranch == branch['name']) {
                        _selectedBranch = null;
                        _animationController.reverse();
                      } else {
                        _selectedBranch = branch['name'];
                        _animationController.forward();
                      }
                    });
                    widget.onBranchSelected(_selectedBranch ?? '');
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: isSelected ? branch['gradient'] : null,
                      color: isSelected ? null : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isSelected 
                              ? branch['color'].withOpacity(0.4) 
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: isSelected 
                          ? null 
                          : Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with animation
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.8, 
                            end: isSelected ? 1.0 : 0.8
                          ),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected 
                                      ? Colors.white.withOpacity(0.9) 
                                      : Colors.grey.shade50,
                                ),
                                child: Image.asset(
                                  branch['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        // Branch name
                        Text(
                          branch['name'],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}