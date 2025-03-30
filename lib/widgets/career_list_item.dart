import 'package:flutter/material.dart';
import '../models/military_career.dart';
import '../utils/theme.dart';

class CareerListItem extends StatelessWidget {
  final MilitaryCareer career;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  
  const CareerListItem({
    Key? key,
    required this.career,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color branchColor;
    
    switch (career.branchId) {
      case 'army':
        branchColor = MilitaryTheme.army;
        break;
      case 'navy':
        branchColor = MilitaryTheme.navyBlue;
        break;
      case 'airforce':
        branchColor = MilitaryTheme.airForce;
        break;
      case 'marines':
        branchColor = MilitaryTheme.marines;
        break;
      case 'coastguard':
        branchColor = MilitaryTheme.coastGuard;
        break;
      case 'spaceforce':
        branchColor = MilitaryTheme.spaceForce;
        break;
      default:
        branchColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Branch color indicator
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                  color: branchColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              
              // Career info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        Text(
                          career.code,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Roboto Condensed',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            career.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Branch
                    Text(
                      career.branchName,
                      style: TextStyle(
                        color: branchColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    Text(
                      career.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Favorite button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriteTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}