import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Displays detailed information about a SampleItem.
// class SampleItemDetailsView extends StatelessWidget {
//   const SampleItemDetailsView({super.key});

//   static const routeName = '/sample_item';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Item Details'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('More Information Here'),
//             const SizedBox(height: 20),
//             const Text('More Information yay'), 
//              const Text(
//               'Hello, Flutter!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),   
//             const SizedBox(height: 20),
//             Image.network(
//               'https://via.placeholder.com/150',
//               width: 150,
//               height: 150,
//             ),
//             const SizedBox(height: 20), 
//             const Text('yaya') 
//           ]
//         )
//       ),
//     );
//   }
// }


class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

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
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

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