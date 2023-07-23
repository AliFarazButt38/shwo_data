
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataManage extends StatefulWidget {
  const DataManage({Key? key}) : super(key: key);

  @override
  State<DataManage> createState() => _DataManageState();
}

class _DataManageState extends State<DataManage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  List<DataRow> _dataRows = [];
  List<DataColumn> columns = [
    DataColumn(label: Text('Name')),
    DataColumn(label: Text('Age')),
    DataColumn(label: Text('Address')),
    DataColumn(label: Text('Email')),
    DataColumn(label: Text('Class')),
  ];

  @override
  void initState() {
    super.initState();
    loadTableData();
  }

  Future<void> loadTableData() async {
    final prefs = await SharedPreferences.getInstance();
    final tableData = prefs.getStringList('tableData');
    if (tableData != null) {
      setState(() {
        _dataRows = tableData.map((rowData) {
          final cells = rowData.split(',');
          return DataRow(
            cells: cells.map((cellData) => DataCell(Text(cellData))).toList(),
          );
        }).toList();
      });
    }
  }

  Future<void> saveTableData() async {
    final prefs = await SharedPreferences.getInstance();
    final tableData = _dataRows.map((dataRow) {
      final cells = dataRow.cells.map((dataCell) => dataCell.child as Text).toList();
      return cells.map((text) => text.data!).join(',');
    }).toList();
    await prefs.setStringList('tableData', tableData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an age';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _classController,
                      decoration: InputDecoration(labelText: 'Class'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a class';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            final newRow = DataRow(
                              cells: [
                                DataCell(Text(_nameController.text)),
                                DataCell(Text(_ageController.text)),
                                DataCell(Text(_addressController.text)),
                                DataCell(Text(_emailController.text)),
                                DataCell(Text(_classController.text)),
                              ],
                            );

                            // Check the number of cells in the new row
                            if (newRow.cells.length == columns.length) {
                              _dataRows.add(newRow);
                              _nameController.clear();
                              _ageController.clear();
                              _addressController.clear();
                              _emailController.clear();
                              _classController.clear();

                              saveTableData(); // Save the updated table data
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text('The number of cells in the row does not match the number of columns.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: Text('Add to Table'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    sortAscending: true,
                    dataRowHeight: 40,
                    headingRowColor:   MaterialStateColor.resolveWith((states) => Colors.redAccent),
                    dataRowColor: MaterialStateColor.resolveWith((states) => Colors.greenAccent),
                    // dividerThickness: 0,
                    // columnSpacing: 1,
                    clipBehavior: Clip.none,
                    showCheckboxColumn: true,
                    // horizontalMargin: 20,

                    columns:

                    columns,
                    rows:

                    _dataRows,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
