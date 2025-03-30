import 'package:flutter/material.dart';
import '../utils/theme.dart';

class RecruiterFinderScreen extends StatefulWidget {
  const RecruiterFinderScreen({Key? key}) : super(key: key);

  @override
  State<RecruiterFinderScreen> createState() => _RecruiterFinderScreenState();
}

class _RecruiterFinderScreenState extends State<RecruiterFinderScreen> {
  String _selectedBranch = 'all';
  bool _locationPermissionGranted = false;
  bool _isLoading = false;
  
  // Mock recruiter data - to be replaced with real API call
  final List<Map<String, dynamic>> _recruiters = [
    {
      'id': '1',
      'name': 'SSG John Smith',
      'branch': 'army',
      'branchName': 'U.S. Army',
      'address': '123 Military Plaza, Springfield, IL 62701',
      'phone': '(555) 123-4567',
      'email': 'john.smith@army.mil',
      'distance': 2.7,
    },
    {
      'id': '2',
      'name': 'PO1 Sarah Johnson',
      'branch': 'navy',
      'branchName': 'U.S. Navy',
      'address': '456 Anchor Avenue, Springfield, IL 62702',
      'phone': '(555) 234-5678',
      'email': 'sarah.johnson@navy.mil',
      'distance': 3.4,
    },
    {
      'id': '3',
      'name': 'SSgt Michael Rodriguez',
      'branch': 'airforce',
      'branchName': 'U.S. Air Force',
      'address': '789 Eagle Street, Springfield, IL 62703',
      'phone': '(555) 345-6789',
      'email': 'michael.rodriguez@airforce.mil',
      'distance': 4.1,
    },
    {
      'id': '4',
      'name': 'Sgt James Wilson',
      'branch': 'marines',
      'branchName': 'U.S. Marine Corps',
      'address': '101 Semper Fi Blvd, Springfield, IL 62704',
      'phone': '(555) 456-7890',
      'email': 'james.wilson@marines.mil',
      'distance': 5.8,
    },
    {
      'id': '5',
      'name': 'BMC Lisa Thompson',
      'branch': 'coastguard',
      'branchName': 'U.S. Coast Guard',
      'address': '202 Harbor Road, Springfield, IL 62705',
      'phone': '(555) 567-8901',
      'email': 'lisa.thompson@uscg.mil',
      'distance': 6.5,
    },
    {
      'id': '6',
      'name': 'Capt Alex Rivera',
      'branch': 'spaceforce',
      'branchName': 'U.S. Space Force',
      'address': '303 Galaxy Drive, Springfield, IL 62706',
      'phone': '(555) 678-9012',
      'email': 'alex.rivera@spaceforce.mil',
      'distance': 7.3,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }
  
  Future<void> _requestLocationPermission() async {
    // Simulate permission request
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _locationPermissionGranted = true;
      _isLoading = false;
    });
  }
  
  List<Map<String, dynamic>> get filteredRecruiters {
    if (_selectedBranch == 'all') {
      return _recruiters;
    } else {
      return _recruiters.where((recruiter) => recruiter['branch'] == _selectedBranch).toList();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruiter Finder'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_locationPermissionGranted
              ? _buildLocationPermissionRequest()
              : Column(
                  children: [
                    // Map placeholder
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Map View\n(Coming Soon)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    // Branch filter
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter by Branch',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildBranchFilterChip('All', 'all', Colors.grey),
                                _buildBranchFilterChip('Army', 'army', MilitaryTheme.army),
                                _buildBranchFilterChip('Navy', 'navy', MilitaryTheme.navyBlue),
                                _buildBranchFilterChip('Air Force', 'airforce', MilitaryTheme.airForce),
                                _buildBranchFilterChip('Marines', 'marines', MilitaryTheme.marines),
                                _buildBranchFilterChip('Coast Guard', 'coastguard', MilitaryTheme.coastGuard),
                                _buildBranchFilterChip('Space Force', 'spaceforce', MilitaryTheme.spaceForce),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Results count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            '${filteredRecruiters.length} ${filteredRecruiters.length == 1 ? 'Recruiter' : 'Recruiters'} Found',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            onPressed: () {
                              // Refresh recruiter list
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Refreshing recruiter list...')),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    // Recruiter list
                    Expanded(
                      child: filteredRecruiters.isEmpty
                          ? const Center(
                              child: Text(
                                'No recruiters found for this branch in your area.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8.0),
                              itemCount: filteredRecruiters.length,
                              itemBuilder: (context, index) {
                                final recruiter = filteredRecruiters[index];
                                return _buildRecruiterCard(recruiter);
                              },
                            ),
                    ),
                  ],
                ),
      floatingActionButton: _locationPermissionGranted
          ? FloatingActionButton(
              backgroundColor: MilitaryTheme.navy,
              child: const Icon(Icons.my_location),
              onPressed: () {
                // Center map on user location
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finding recruiters near your location...')),
                );
              },
            )
          : null,
    );
  }
  
  Widget _buildLocationPermissionRequest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Location Permission Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'To find military recruiters near you, we need access to your location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Grant Location Permission'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: _requestLocationPermission,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBranchFilterChip(String label, String value, Color color) {
    final isSelected = _selectedBranch == value;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        checkmarkColor: Colors.white,
        selectedColor: color,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedBranch = selected ? value : 'all';
          });
        },
      ),
    );
  }
  
  Widget _buildRecruiterCard(Map<String, dynamic> recruiter) {
    Color branchColor;
    
    switch (recruiter['branch']) {
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
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: branchColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getBranchIcon(recruiter['branch']),
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  recruiter['branchName'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${recruiter['distance']} mi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recruiter['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        recruiter['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      recruiter['phone'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      recruiter['email'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.place),
                        label: const Text('Directions'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening directions...')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling recruiter...')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getBranchIcon(String branch) {
    switch (branch) {
      case 'army':
        return Icons.military_tech;
      case 'navy':
        return Icons.sailing;
      case 'airforce':
        return Icons.flight;
      case 'marines':
        return Icons.military_tech;
      case 'coastguard':
        return Icons.water;
      case 'spaceforce':
        return Icons.rocket;
      default:
        return Icons.military_tech;
    }
  }
}