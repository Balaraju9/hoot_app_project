import 'package:flutter/material.dart';
import 'package:hoot/Constants/Colors.dart';

class CardSuff extends StatefulWidget {
  const CardSuff({Key? key}) : super(key: key);

  @override
  _CardSuffState createState() => _CardSuffState();
}

class _CardSuffState extends State<CardSuff> {
  bool _showRules = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Short Answer',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        backgroundColor: AppColors.logoGreen,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMainCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Improve Your English Speaking Skills',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900]?.withGreen(1)),
            ),
            SizedBox(height: 20),
            Text(
              'The Short Answer module helps you practice quick thinking and concise speaking in English.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            _buildBenefitsList(),
            SizedBox(height: 20),
            _buildRulesSection(),
            SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benefits:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildBenefitItem('Improve quick thinking in English'),
        _buildBenefitItem('Enhance listening comprehension'),
        _buildBenefitItem('Practice concise and accurate responses'),
        _buildBenefitItem('Get AI-powered feedback on your answers'),
        _buildBenefitItem('Track your progress over time'),
      ],
    );
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 3.0), // Fine-tune this value if needed
              child: Icon(Icons.check_circle,
                  color: AppColors.logoGreen, size: 18),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                benefit,
                style: TextStyle(
                    fontSize: 16,
                    height: 1.4), // Adjust line height for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _showRules = !_showRules;
            });
          },
          child: Row(
            children: [
              Text(
                'Module Rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(_showRules ? Icons.expand_less : Icons.expand_more),
            ],
          ),
        ),
        if (_showRules)
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRuleItem(
                    'Listen to simple questions (e.g., "Will you eat a shoe or an apple?")'),
                _buildRuleItem('You have 10 seconds to respond'),
                _buildRuleItem('Answer in 1-2 words or a short sentence'),
                _buildRuleItem(
                    'AI analyzes your answer for accuracy and relevance'),
                _buildRuleItem(
                    'Your performance data is stored for progress tracking'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(rule, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // Start the module
          },
          icon: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          label: Text('Start Module', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.logoGreen,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            // View statistics
          },
          icon: Icon(Icons.bar_chart, color: Colors.white),
          label: Text('View Stats', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellowForReview,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}
