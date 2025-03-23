import 'package:flutter/material.dart';

class SymptomsScreen extends StatefulWidget {
  // Add optional parameter to receive the current phase color from dashboard
  final Color? phaseColor;
  
  const SymptomsScreen({
    super.key, 
    this.phaseColor,
  });

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  final List<String> _symptomCategories = [
    'Physical',
    'Sex',
    'Mood',
    'Symptoms',
    'Vaginal discharge',
    'Type of vaginal discharge',
    'Other',
  ];
  
  final Map<String, List<String>> _symptoms = {
    'Physical': [
      'Cramps',
      'Headache',
      'Tender breasts',
      'Acne',
      'Bloating',
      'Backache',
      'Nausea',
    ],
    'Sex': [
      'No sex',
      'Protected sex',
      'Unprotected sex',
      'Masturbation',
      'Increased desire',
    ],
    'Mood': [
      'Productive',
      'Energetic',
      'Calm',
      'Sad',
      'Irritable',
    ],
    'Symptoms': [
      'OK',
      'Cramps',
      'Tender breasts',
      'Headache',
      'Fatigue',
    ],
    'Vaginal discharge': [
      'None',
      'Heavy',
      'Medium',
      'Light',
    ],
    'Type of vaginal discharge': [
      'Watery',
      'Mucoid',
      'Creamy',
      'Jelly-like',
      'Spotting',
    ],
    'Other': [
      'Stress',
      'Sickness',
      'Travel',
    ],
  };
  
  final Map<String, bool> _selectedSymptoms = {};
  final TextEditingController _notesController = TextEditingController();
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Use provided phase color or default to pink
    final Color activeColor = widget.phaseColor ?? Colors.pink;
    
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add Symptoms'),
        actions: [
          TextButton(
            onPressed: () {
              // Save symptoms logic here
              saveSymptoms(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: activeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select symptoms you are experiencing today:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Display each category and its symptoms
          ..._symptomCategories.map((category) {
            // Only show the category if it has symptoms
            if (_symptoms.containsKey(category) && _symptoms[category]!.isNotEmpty) {
              return _buildCategorySection(category, activeColor);
            } else {
              return const SizedBox.shrink();
            }
          }),
          
          const SizedBox(height: 24),
          
          // Notes section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: 'Add additional notes...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: activeColor),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                saveSymptoms(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                padding:const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child:const Text('Save Symptoms', style: TextStyle(fontSize: 16)),
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }
  
  Widget _buildCategorySection(String category, Color activeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.grey[200],
          width: double.infinity,
          child: Text(
            category,
            style:const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _symptoms[category]!.map((symptom) {
              return _buildSymptomChip(symptom, activeColor);
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
  
  Widget _buildSymptomChip(String symptom, Color activeColor) {
    final isSelected = _selectedSymptoms[symptom] ?? false;
    
    return FilterChip(
      label: Text(symptom),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSymptoms[symptom] = selected;
        });
      },
      selectedColor: activeColor.withAlpha(50),
      checkmarkColor: activeColor,
      backgroundColor: Colors.grey[100],
      side: BorderSide(
        color: isSelected ? activeColor : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      showCheckmark: true,
      padding:const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? activeColor : Colors.black87,
      ),
    );
  }
  
  void saveSymptoms(BuildContext context) {
    // Get all selected symptom names
    final List<String> selectedSymptoms = _selectedSymptoms.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    
    final String notes = _notesController.text;
    
    // Return data to the calling screen
    Navigator.pop(context, {
      'symptoms': selectedSymptoms,
      'notes': notes,
    });
  }
}