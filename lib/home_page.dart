import 'package:flutter/material.dart';
import 'package:web_test/database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allRows = [];

  TextEditingController artistName = TextEditingController();
  TextEditingController artistDOB = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    query();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Dialog Title'),
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: artistName,
                            decoration: const InputDecoration(
                              label: Text('Enter artist name'),
                            ),
                          ),
                          TextFormField(
                            controller: artistDOB,
                            decoration: const InputDecoration(
                              label: Text('Enter artist DOB'),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (artistName.text.isEmpty ||
                                    artistDOB.text.isEmpty) {
                                  debugPrint('please enter all fields');
                                } else {
                                  _insert(artistName.text,
                                      int.parse(artistDOB.text));
                                  Navigator.pop(context);
                                  query();
                                }
                              },
                              child: Text('SAVE'))
                        ],
                      ),
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name :${allRows[index]['name']}'),
                Text('DOB :${allRows[index]['age']}'),
              ],
            ),
          );
        },
        itemCount: allRows.length,
      ),
    );
  }

  void _insert(String artistName, int artistAge) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: artistName,
      DatabaseHelper.columnAge: artistAge
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }

  void query() async {
    allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach(print);
    setState(() {});
  }
}
