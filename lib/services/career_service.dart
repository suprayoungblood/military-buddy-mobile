import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/military_career.dart';

class CareerService with ChangeNotifier {
  List<MilitaryCareer> _careers = [];
  List<String> _recentlyViewed = [];
  List<String> _favorites = [];
  
  // Getters
  List<MilitaryCareer> get careers => _careers;
  List<MilitaryCareer> get recentlyViewedCareers => 
    _recentlyViewed.map((id) => _careers.firstWhere((career) => career.id == id, orElse: () => MilitaryCareer.empty())).toList();
  List<MilitaryCareer> get favoriteCareers => 
    _favorites.map((id) => _careers.firstWhere((career) => career.id == id, orElse: () => MilitaryCareer.empty())).toList();
  
  // Initialize career data
  Future<void> initialize() async {
    await loadMockCareers();
    await loadUserData();
  }
  
  // Load mock career data
  Future<void> loadMockCareers() async {
    // Mock careers data - to be replaced with data from backend
    _careers = [
      // Army
      MilitaryCareer(
        id: 'army_11b',
        title: 'Infantry',
        branchId: 'army',
        branchName: 'Army',
        code: '11B',
        description: 'Infantry soldiers are the main land combat force and backbone of the Army. They are responsible for defending our country against any threat by land, as well as capturing, destroying and repelling enemy ground forces.',
        duties: [
          'Assist in the performance of reconnaissance operations',
          'Employ, fire, and recover anti-personnel and anti-tank mines',
          'Locate and neutralize mines',
          'Operate and maintain communications equipment',
          'Operate in a radio net',
          'Perform as a member of a fire team during training and combat exercises',
          'Process prisoners of war and captured documents',
        ],
        requirements: {
          'asvab': {
            'GT': 90,
          },
          'physical': 'High physical demands',
          'securityClearance': 'None',
        },
        trainingLocation: 'Fort Benning, GA',
        trainingDuration: '14 weeks',
        advancement: 'Opportunities to advance to Special Forces, Rangers, or leadership positions.',
        relatedCivilianJobs: ['Police Officer', 'Security Specialist', 'Tactical Trainer'],
      ),
      
      MilitaryCareer(
        id: 'army_68w',
        title: 'Combat Medic Specialist',
        branchId: 'army',
        branchName: 'Army',
        code: '68W',
        description: 'Combat Medic Specialists provide emergency medical treatment, limited primary care, and force health protection at the point of injury on the battlefield or during training.',
        duties: [
          'Administer emergency medical treatment to battlefield casualties',
          'Assist with outpatient and inpatient care',
          'Prepare blood samples for laboratory analysis',
          'Prepare patients, operating rooms, equipment and supplies for surgery',
          'Take patient histories and vital signs',
        ],
        requirements: {
          'asvab': {
            'ST': 101,
          },
          'physical': 'Moderate physical demands',
          'securityClearance': 'None',
        },
        trainingLocation: 'Fort Sam Houston, TX',
        trainingDuration: '16 weeks',
        advancement: 'Opportunities to become a licensed practical nurse, physician assistant, or other medical professional.',
        relatedCivilianJobs: ['EMT', 'Paramedic', 'Medical Assistant', 'Healthcare Specialist'],
      ),
      
      // Navy
      MilitaryCareer(
        id: 'navy_nuke',
        title: 'Nuclear Engineer',
        branchId: 'navy',
        branchName: 'Navy',
        code: 'NF',
        description: 'Navy Nuclear Engineers are responsible for the operation, maintenance, and supervision of propulsion plants of nuclear-powered vessels.',
        duties: [
          'Operate ship propulsion equipment',
          'Maintain electrical, mechanical, and reactor control systems',
          'Perform tests, maintenance, and repairs on nuclear propulsion plants',
          'Monitor and adjust reactor plant conditions',
          'Ensure safety procedures are followed',
        ],
        requirements: {
          'asvab': {
            'VE': 50,
            'AR': 50,
            'MK': 50,
            'MC': 50,
          },
          'physical': 'Moderate physical demands',
          'securityClearance': 'Secret',
        },
        trainingLocation: 'Charleston, SC',
        trainingDuration: '18 months',
        advancement: 'Opportunities for commission as an officer or civilian careers in nuclear industry.',
        relatedCivilianJobs: ['Nuclear Engineer', 'Power Plant Operator', 'Reactor Operator'],
      ),
      
      // Air Force
      MilitaryCareer(
        id: 'af_1a8x1',
        title: 'Airborne Cryptologic Language Analyst',
        branchId: 'airforce',
        branchName: 'Air Force',
        code: '1A8X1',
        description: 'Airborne Cryptologic Language Analysts collect and analyze foreign language communications to support national security.',
        duties: [
          'Operate airborne signals intelligence collection equipment',
          'Analyze and interpret foreign communications',
          'Translate foreign language documents',
          'Provide language expertise to support intelligence operations',
          'Create reports on intelligence findings',
        ],
        requirements: {
          'asvab': {
            'G': 72,
          },
          'physical': 'Moderate physical demands',
          'securityClearance': 'Top Secret/SCI',
        },
        trainingLocation: 'Goodfellow AFB, TX & Defense Language Institute, CA',
        trainingDuration: '6-18 months depending on language',
        advancement: 'Opportunities for officer commission or civilian intelligence careers.',
        relatedCivilianJobs: ['Linguist', 'Translator', 'Intelligence Analyst'],
      ),
      
      // Marines
      MilitaryCareer(
        id: 'usmc_0311',
        title: 'Rifleman',
        branchId: 'marines',
        branchName: 'Marines',
        code: '0311',
        description: 'Marine Riflemen are the foundation of the Marine Corps infantry. They are trained to deploy by air, land or sea to engage enemies with rifle fire and close combat.',
        duties: [
          'Employ, fire, and recover anti-personnel and anti-tank mines',
          'Operate and maintain communications equipment',
          'Operate in a rifle squad during combat operations',
          'Perform scouting and patrolling operations',
          'Process prisoners of war and captured documents',
        ],
        requirements: {
          'asvab': {
            'GT': 90,
          },
          'physical': 'High physical demands',
          'securityClearance': 'None',
        },
        trainingLocation: 'Parris Island, SC or San Diego, CA, then School of Infantry',
        trainingDuration: '13 weeks basic training + 8 weeks infantry training',
        advancement: 'Opportunities for special operations, leadership positions, or officer commission.',
        relatedCivilianJobs: ['Police Officer', 'Security Specialist', 'Tactical Trainer'],
      ),
      
      // Coast Guard
      MilitaryCareer(
        id: 'uscg_me',
        title: 'Maritime Enforcement Specialist',
        branchId: 'coastguard',
        branchName: 'Coast Guard',
        code: 'ME',
        description: 'Maritime Enforcement Specialists conduct law enforcement, homeland security, and force protection operations.',
        duties: [
          'Conduct security and anti-terrorism operations',
          'Enforce U.S. and international maritime law',
          'Participate in search and rescue operations',
          'Conduct vessel boardings and inspections',
          'Process suspects and detainees',
        ],
        requirements: {
          'asvab': {
            'VE': 56,
            'AR': 51,
          },
          'physical': 'High physical demands',
          'securityClearance': 'Secret',
        },
        trainingLocation: 'Cape May, NJ then Maritime Enforcement School',
        trainingDuration: '8 weeks basic training + 8 weeks ME school',
        advancement: 'Opportunities for leadership positions or officer commission.',
        relatedCivilianJobs: ['Police Officer', 'Federal Agent', 'Security Specialist'],
      ),
      
      // Space Force
      MilitaryCareer(
        id: 'sf_5s0x1',
        title: 'Space Systems Operations',
        branchId: 'spaceforce',
        branchName: 'Space Force',
        code: '5S0X1',
        description: 'Space Systems Operators conduct space operations and maintain space systems to support national security objectives.',
        duties: [
          'Operate satellite communication systems',
          'Monitor space surveillance networks',
          'Track objects in Earth orbit',
          'Analyze space threats and events',
          'Support missile warning and defense systems',
        ],
        requirements: {
          'asvab': {
            'G': 57,
            'E': 50,
          },
          'physical': 'Moderate physical demands',
          'securityClearance': 'Top Secret/SCI',
        },
        trainingLocation: 'Vandenberg Space Force Base, CA',
        trainingDuration: '12 weeks',
        advancement: 'Opportunities for leadership positions, advanced technical training, or officer commission.',
        relatedCivilianJobs: ['Satellite Systems Operator', 'Aerospace Technician', 'Defense Contractor'],
      ),
    ];
    
    notifyListeners();
  }
  
  // Load user data (recently viewed, favorites)
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load recently viewed careers
      final recentlyViewedJson = prefs.getStringList('recently_viewed_careers') ?? [];
      _recentlyViewed = recentlyViewedJson;
      
      // Load favorite careers
      final favoritesJson = prefs.getStringList('favorite_careers') ?? [];
      _favorites = favoritesJson;
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading career user data: $e');
      }
    }
  }
  
  // Save user data
  Future<void> saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save recently viewed careers
      prefs.setStringList('recently_viewed_careers', _recentlyViewed);
      
      // Save favorite careers
      prefs.setStringList('favorite_careers', _favorites);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving career user data: $e');
      }
    }
  }
  
  // Get career by ID
  MilitaryCareer? getCareerById(String id) {
    try {
      return _careers.firstWhere((career) => career.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Add career to recently viewed
  Future<void> addToRecentlyViewed(String careerId) async {
    // Remove if already exists
    _recentlyViewed.remove(careerId);
    
    // Add to beginning of list
    _recentlyViewed.insert(0, careerId);
    
    // Limit to 10 items
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }
    
    await saveUserData();
    notifyListeners();
  }
  
  // Toggle favorite status
  Future<void> toggleFavorite(String careerId) async {
    if (_favorites.contains(careerId)) {
      _favorites.remove(careerId);
    } else {
      _favorites.add(careerId);
    }
    
    await saveUserData();
    notifyListeners();
  }
  
  // Check if career is favorite
  bool isFavorite(String careerId) {
    return _favorites.contains(careerId);
  }
  
  // Get careers by branch
  List<MilitaryCareer> getCareersByBranch(String branchId) {
    return _careers.where((career) => career.branchId == branchId).toList();
  }
  
  // Search careers
  List<MilitaryCareer> searchCareers(String query) {
    query = query.toLowerCase();
    return _careers.where((career) => 
      career.title.toLowerCase().contains(query) || 
      career.code.toLowerCase().contains(query) || 
      career.description.toLowerCase().contains(query)
    ).toList();
  }
  
  // Filter careers by requirements
  List<MilitaryCareer> filterCareersByASVAB(Map<String, int> scores) {
    return _careers.where((career) {
      final requirements = career.requirements['asvab'] as Map<String, dynamic>?;
      if (requirements == null) return true;
      
      bool meetsRequirements = true;
      requirements.forEach((key, value) {
        if (scores.containsKey(key) && scores[key]! < value) {
          meetsRequirements = false;
        }
      });
      
      return meetsRequirements;
    }).toList();
  }
}