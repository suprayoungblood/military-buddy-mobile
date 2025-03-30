import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/career_service.dart';
import '../models/military_career.dart';
import '../utils/theme.dart';
import '../widgets/branch_filter_button.dart';
import '../widgets/career_list_item.dart';

class CareerExplorerScreen extends StatefulWidget {
  const CareerExplorerScreen({Key? key}) : super(key: key);

  @override
  State<CareerExplorerScreen> createState() => _CareerExplorerScreenState();
}

class _CareerExplorerScreenState extends State<CareerExplorerScreen> {
  String _selectedBranch = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Initialize career data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CareerService>(context, listen: false).initialize();
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterByBranch(String branchId) {
    setState(() {
      if (_selectedBranch == branchId) {
        // Toggle off if already selected
        _selectedBranch = '';
      } else {
        _selectedBranch = branchId;
      }
    });
  }
  
  void _searchCareers(String query) {
    setState(() {
      _searchQuery = query;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final careerService = Provider.of<CareerService>(context);
    
    // Apply filters
    List<MilitaryCareer> filteredCareers = careerService.careers;
    
    if (_selectedBranch.isNotEmpty) {
      filteredCareers = filteredCareers.where((career) => career.branchId == _selectedBranch).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filteredCareers = careerService.searchCareers(_searchQuery);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Explorer'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by job title, code, or keyword...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchCareers('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _searchCareers,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Branch filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BranchFilterButton(
                    label: 'Army',
                    branchId: 'army',
                    color: MilitaryTheme.army,
                    isSelected: _selectedBranch == 'army',
                    onTap: () => _filterByBranch('army'),
                  ),
                  BranchFilterButton(
                    label: 'Navy',
                    branchId: 'navy',
                    color: MilitaryTheme.navyBlue,
                    isSelected: _selectedBranch == 'navy',
                    onTap: () => _filterByBranch('navy'),
                  ),
                  BranchFilterButton(
                    label: 'Air Force',
                    branchId: 'airforce',
                    color: MilitaryTheme.airForce,
                    isSelected: _selectedBranch == 'airforce',
                    onTap: () => _filterByBranch('airforce'),
                  ),
                  BranchFilterButton(
                    label: 'Marines',
                    branchId: 'marines',
                    color: MilitaryTheme.marines,
                    isSelected: _selectedBranch == 'marines',
                    onTap: () => _filterByBranch('marines'),
                  ),
                  BranchFilterButton(
                    label: 'Coast Guard',
                    branchId: 'coastguard',
                    color: MilitaryTheme.coastGuard,
                    isSelected: _selectedBranch == 'coastguard',
                    onTap: () => _filterByBranch('coastguard'),
                  ),
                  BranchFilterButton(
                    label: 'Space Force',
                    branchId: 'spaceforce',
                    color: MilitaryTheme.spaceForce,
                    isSelected: _selectedBranch == 'spaceforce',
                    onTap: () => _filterByBranch('spaceforce'),
                  ),
                ],
              ),
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Text(
                  '${filteredCareers.length} ${filteredCareers.length == 1 ? 'Career' : 'Careers'} Found',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (_selectedBranch.isNotEmpty || _searchQuery.isNotEmpty)
                  TextButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Filters'),
                    onPressed: () {
                      setState(() {
                        _selectedBranch = '';
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
          
          // Career list
          Expanded(
            child: filteredCareers.isEmpty
                ? const Center(
                    child: Text(
                      'No careers found. Try adjusting your filters.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredCareers.length,
                    itemBuilder: (context, index) {
                      final career = filteredCareers[index];
                      return CareerListItem(
                        career: career,
                        isFavorite: careerService.isFavorite(career.id),
                        onTap: () {
                          careerService.addToRecentlyViewed(career.id);
                          _navigateToCareerDetail(context, career.id);
                        },
                        onFavoriteTap: () {
                          careerService.toggleFavorite(career.id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToCareerDetail(BuildContext context, String careerId) {
    Navigator.pushNamed(
      context,
      '/career_detail',
      arguments: careerId,
    );
  }
}