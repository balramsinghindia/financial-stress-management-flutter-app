import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key, required this.client});

  static const routeName = '/sample_item';
  final http.Client client;

  @override
  _SampleItemDetailsViewState createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  String _text = 'Hello, Flutter!';
  String _apiResponse = 'This is a sample text inside a container.';

  void _changeText() {
    setState(() {
      _text = _text == 'Hello, Flutter!' ? 'Bye, Flutter!' : 'Hello, Flutter!';
    });
  }

  Future<void> _fetchData() async {
    final response = await widget.client.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

    if (response.statusCode == 200) {
      setState(() {
        _apiResponse = json.decode(response.body)['title'];
      });
    } else {
      setState(() {
        _apiResponse = 'Failed to load data.';
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controller for the text field
  final TextEditingController _textController = TextEditingController();

  // Initial value for the dropdown
  String _dropdownValue = 'Option 1';

  // Checkbox state
  bool _checkboxValue = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, send data to abc.com (simulating navigation)
      // Replace with your actual API call or navigation logic
      print('Form is valid. Submitting data to abc.com');
    } else {
      print('Form is invalid. Please review and correct errors.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _changeText,
              child: Text(
                _text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Image.network(
              'https://via.placeholder.com/150',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: _dropdownValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an option';
                        }
                        return null;
                      },
                      items: <String>['Option 1', 'Option 2', 'Option 3']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(labelText: 'Enter text'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value.length > 3) {
                          return 'Text must not exceed 3 characters';
                        }
                        return null;
                      },
                      maxLength: 3,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _checkboxValue,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _checkboxValue = newValue!;
                            });
                          },
                        ),
                        Text('Checkbox'),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: Text(
                'This is a sample text inside a container.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
              onTap: _fetchData,
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Text(
                  _apiResponse,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
