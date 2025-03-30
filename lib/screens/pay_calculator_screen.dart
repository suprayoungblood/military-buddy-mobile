import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';

class PayCalculatorScreen extends StatefulWidget {
  const PayCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<PayCalculatorScreen> createState() => _PayCalculatorScreenState();
}

class _PayCalculatorScreenState extends State<PayCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form values
  String _rankGroup = 'enlisted'; // 'enlisted', 'warrant', 'officer'
  String _rank = 'E-1';
  int _yearsOfService = 0;
  bool _hasDependents = false;
  String _zipCode = '';
  bool _livesOnBase = false;
  
  // Results
  double _basePay = 0;
  double _bah = 0;
  double _bas = 0;
  double _totalPay = 0;
  bool _showResults = false;
  
  final Map<String, List<String>> _rankOptions = {
    'enlisted': ['E-1', 'E-2', 'E-3', 'E-4', 'E-5', 'E-6', 'E-7', 'E-8', 'E-9'],
    'warrant': ['W-1', 'W-2', 'W-3', 'W-4', 'W-5'],
    'officer': ['O-1', 'O-2', 'O-3', 'O-4', 'O-5', 'O-6', 'O-7', 'O-8', 'O-9', 'O-10'],
  };
  
  final List<int> _yearsOptions = [0, 1, 2, 3, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 30];
  
  @override
  void initState() {
    super.initState();
    // Set default values
    _rank = _rankOptions[_rankGroup]!.first;
  }
  
  void _calculatePay() {
    if (_formKey.currentState?.validate() ?? false) {
      // Mock calculation - to be replaced with actual calculations
      
      // Base pay calculation (simplified mock)
      double basePay = 0;
      
      if (_rankGroup == 'enlisted') {
        switch (_rank) {
          case 'E-1':
            basePay = 1785.00;
            break;
          case 'E-2':
            basePay = 2001.30;
            break;
          case 'E-3':
            basePay = 2103.90;
            break;
          case 'E-4':
            basePay = 2330.40;
            break;
          case 'E-5':
            basePay = 2541.60;
            break;
          case 'E-6':
            basePay = 2774.40;
            break;
          case 'E-7':
            basePay = 3210.30;
            break;
          case 'E-8':
            basePay = 4614.60;
            break;
          case 'E-9':
            basePay = 5637.00;
            break;
        }
      } else if (_rankGroup == 'warrant') {
        switch (_rank) {
          case 'W-1':
            basePay = 3213.30;
            break;
          case 'W-2':
            basePay = 3661.20;
            break;
          case 'W-3':
            basePay = 4146.60;
            break;
          case 'W-4':
            basePay = 4537.50;
            break;
          case 'W-5':
            basePay = 0.00; // Set actual value
            break;
        }
      } else if (_rankGroup == 'officer') {
        switch (_rank) {
          case 'O-1':
            basePay = 3477.30;
            break;
          case 'O-2':
            basePay = 4006.50;
            break;
          case 'O-3':
            basePay = 4636.50;
            break;
          case 'O-4':
            basePay = 5273.70;
            break;
          case 'O-5':
            basePay = 6112.20;
            break;
          case 'O-6':
            basePay = 7332.00;
            break;
          case 'O-7':
            basePay = 9668.70;
            break;
          default:
            basePay = 11000.00; // Simplified for higher ranks
            break;
        }
      }
      
      // Adjust for years of service (simplified)
      if (_yearsOfService >= 2) {
        basePay *= 1.03;
      }
      if (_yearsOfService >= 4) {
        basePay *= 1.05;
      }
      if (_yearsOfService >= 6) {
        basePay *= 1.03;
      }
      if (_yearsOfService >= 10) {
        basePay *= 1.05;
      }
      if (_yearsOfService >= 20) {
        basePay *= 1.10;
      }
      
      // Mock BAH calculation
      double bah = 0;
      if (!_livesOnBase) {
        // Mock BAH based on rank
        if (_rankGroup == 'enlisted') {
          switch (_rank) {
            case 'E-1':
            case 'E-2':
            case 'E-3':
              bah = _hasDependents ? 1200 : 900;
              break;
            case 'E-4':
            case 'E-5':
              bah = _hasDependents ? 1500 : 1100;
              break;
            case 'E-6':
            case 'E-7':
              bah = _hasDependents ? 1800 : 1300;
              break;
            case 'E-8':
            case 'E-9':
              bah = _hasDependents ? 2100 : 1500;
              break;
          }
        } else if (_rankGroup == 'warrant') {
          bah = _hasDependents ? 2000 : 1400;
        } else if (_rankGroup == 'officer') {
          switch (_rank) {
            case 'O-1':
            case 'O-2':
              bah = _hasDependents ? 1900 : 1400;
              break;
            case 'O-3':
            case 'O-4':
              bah = _hasDependents ? 2200 : 1600;
              break;
            default:
              bah = _hasDependents ? 2500 : 1800;
              break;
          }
        }
        
        // Adjust BAH based on ZIP code (simplified mock)
        // In a real app, this would use a lookup table or API
        if (_zipCode.startsWith('9')) {
          // High cost area (e.g. California)
          bah *= 1.3;
        } else if (_zipCode.startsWith('1') || _zipCode.startsWith('2')) {
          // Medium-high cost (e.g. Northeast)
          bah *= 1.2;
        } else if (_zipCode.startsWith('3') || _zipCode.startsWith('6')) {
          // Medium cost
          bah *= 1.1;
        }
      }
      
      // BAS calculation (simplified)
      double bas = _rankGroup == 'enlisted' ? 406.98 : 280.29;
      
      // Calculate total
      double totalPay = basePay + bah + bas;
      
      setState(() {
        _basePay = basePay;
        _bah = bah;
        _bas = bas;
        _totalPay = totalPay;
        _showResults = true;
      });
    }
  }
  
  void _resetForm() {
    setState(() {
      _rankGroup = 'enlisted';
      _rank = 'E-1';
      _yearsOfService = 0;
      _hasDependents = false;
      _zipCode = '';
      _livesOnBase = false;
      _showResults = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Military Pay Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: MilitaryTheme.navy,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'About Military Pay',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: MilitaryTheme.navy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Military compensation includes:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Basic Pay - Based on rank and years of service'),
                    const Text('• BAH (Housing Allowance) - Based on location, rank, and dependents'),
                    const Text('• BAS (Food Allowance) - Basic allowance for subsistence'),
                    const SizedBox(height: 12),
                    const Text(
                      'Note: This calculator provides estimates only. Actual pay may vary based on special pays, allowances, and tax considerations.',
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            
            // Pay calculator form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rank selection
                  const Text(
                    'Pay Grade',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Rank group selector
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'enlisted',
                              label: Text('Enlisted'),
                            ),
                            ButtonSegment(
                              value: 'warrant',
                              label: Text('Warrant'),
                            ),
                            ButtonSegment(
                              value: 'officer',
                              label: Text('Officer'),
                            ),
                          ],
                          selected: {_rankGroup},
                          onSelectionChanged: (Set<String> selection) {
                            setState(() {
                              _rankGroup = selection.first;
                              _rank = _rankOptions[_rankGroup]!.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Specific rank dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Rank',
                      border: OutlineInputBorder(),
                    ),
                    value: _rank,
                    items: _rankOptions[_rankGroup]!.map((rank) {
                      return DropdownMenuItem<String>(
                        value: rank,
                        child: Text(rank),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _rank = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Years of service
                  DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Years of Service',
                      border: OutlineInputBorder(),
                    ),
                    value: _yearsOfService,
                    items: _yearsOptions.map((years) {
                      return DropdownMenuItem<int>(
                        value: years,
                        child: Text('$years ${years == 1 ? 'year' : 'years'}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _yearsOfService = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Dependents
                  SwitchListTile(
                    title: const Text('Have Dependents'),
                    subtitle: const Text('Spouse and/or children'),
                    value: _hasDependents,
                    onChanged: (value) {
                      setState(() {
                        _hasDependents = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 8),
                  
                  // Housing situation
                  SwitchListTile(
                    title: const Text('Lives On Base'),
                    subtitle: const Text('Government-provided housing'),
                    value: _livesOnBase,
                    onChanged: (value) {
                      setState(() {
                        _livesOnBase = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  
                  // ZIP code
                  if (!_livesOnBase)
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'ZIP Code',
                        hintText: 'For BAH calculation',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _zipCode = value;
                        });
                      },
                      validator: (value) {
                        if (!_livesOnBase && (value == null || value.isEmpty)) {
                          return 'Please enter ZIP code';
                        }
                        if (!_livesOnBase && value!.length != 5) {
                          return 'Please enter a valid 5-digit ZIP code';
                        }
                        return null;
                      },
                    ),
                  
                  const SizedBox(height: 24),
                  
                  // Calculate button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MilitaryTheme.navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _calculatePay,
                          child: const Text(
                            'Calculate Pay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  if (_showResults) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    
                    // Results
                    const Text(
                      'Estimated Monthly Pay',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Results card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildPayRow('Basic Pay', _basePay, currencyFormat),
                            const Divider(),
                            _buildPayRow('BAH (Housing)', _bah, currencyFormat),
                            const Divider(),
                            _buildPayRow('BAS (Food)', _bas, currencyFormat),
                            const Divider(),
                            _buildPayRow('Total Monthly', _totalPay, currencyFormat, isTotal: true),
                            const SizedBox(height: 16),
                            Text(
                              'Estimated Annual: ${currencyFormat.format(_totalPay * 12)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Reset button
                    TextButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Calculator'),
                      onPressed: _resetForm,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Disclaimer
                    const Text(
                      'Disclaimer: These figures are estimates based on 2023 pay tables. Actual pay may vary based on specific circumstances, locality adjustments, special pays, and other factors.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPayRow(String label, double amount, NumberFormat formatter, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            formatter.format(amount),
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? MilitaryTheme.navy : null,
            ),
          ),
        ],
      ),
    );
  }
}