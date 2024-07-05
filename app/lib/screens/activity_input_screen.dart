import 'package:flutter/material.dart';

class ActivityInputScreen extends StatefulWidget {
  @override
  _ActivityInputScreenState createState() => _ActivityInputScreenState();
}

class _ActivityInputScreenState extends State<ActivityInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Daily Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _activityController,
                decoration: InputDecoration(labelText: 'Activity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an activity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // GPT API 호출 및 활동 저장 로직 추가
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Activity logged: ${_activityController.text}')),
                    );
                    _activityController.clear();
                  }
                },
                child: Text('Log Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }
}