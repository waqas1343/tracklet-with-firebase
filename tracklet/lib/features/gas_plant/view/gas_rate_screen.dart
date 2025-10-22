import 'package:flutter/material.dart';

class GasRateScreen extends StatefulWidget {
  const GasRateScreen({Key? key}) : super(key: key);

  @override
  State<GasRateScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<GasRateScreen> {
  final TextEditingController _addRateController = TextEditingController();

  final List<Map<String, dynamic>> _rateHistory = [
    {"date": "20-Sep-25", "sales": 3200, "rate": 250},
    {"date": "19-Sep-25", "sales": 2800, "rate": 264},
    {"date": "18-Sep-25", "sales": 3000, "rate": 260},
    {"date": "17-Sep-25", "sales": 4000, "rate": 250},
    {"date": "16-Sep-25", "sales": 6000, "rate": 200},
    {"date": "15-Sep-25", "sales": 3000, "rate": 250},
    {"date": "14-Sep-25", "sales": 3000, "rate": 250},
    {"date": "13-Sep-25", "sales": 3000, "rate": 250},
    {"date": "12-Sep-25", "sales": 3000, "rate": 250},
    {"date": "11-Sep-25", "sales": 3000, "rate": 250},
  ];

  int _todayRate = 250;

  @override
  void dispose() {
    _addRateController.dispose();
    super.dispose();
  }

  void _addNewRate() {
    if (_addRateController.text.isEmpty) return;
    final int? newRate = int.tryParse(_addRateController.text);
    if (newRate == null) return;

    setState(() {
      // Update today's rate
      _todayRate = newRate;

      // Add new entry to rate history with current date (static example date)
      _rateHistory.insert(0, {
        "date": "22-Oct-25", // In real app, use current date dynamically
        "sales": 0, // You can update sales too dynamically if needed
        "rate": newRate,
      });

      // Clear input field
      _addRateController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: navy,
        title: Text(
          "Today Rate per KG:",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: navy,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Today Rate display
            Text(
              "$_todayRate PKR",
              style: TextStyle(
                color: navy,
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showAddRateDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                child: Text("Add Rate"),
              ),
            ),
            SizedBox(height: 20),
            // Rate History label and filters (static UI)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Rate history:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: navy,
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SearchField(hintText: "Search Date"),
                ),
                SizedBox(width: 12),
                _DropdownFilterButton(title: "Month"),
                SizedBox(width: 12),
                _DropdownFilterButton(title: "Rates"),
              ],
            ),
            SizedBox(height: 18),
            // Table headers
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    "Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Total Sales (KG)",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Rate per KG",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: navy,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Rate history list
            Expanded(
              child: ListView.builder(
                itemCount: _rateHistory.length,
                itemBuilder: (context, index) {
                  final item = _rateHistory[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            item['date'],
                            style: TextStyle(color: navy, fontSize: 14),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "${item['sales']} KG",
                            style: TextStyle(color: navy, fontSize: 14),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 14),
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item['rate'].toString(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to enter new rate
  void _showAddRateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add New Rate"),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: _addRateController,
          decoration: InputDecoration(
            hintText: "Enter new rate",
            prefixIcon: Icon(Icons.attach_money),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addRateController.clear();
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _addNewRate();
              Navigator.of(context).pop();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hintText;
  const _SearchField({required this.hintText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);
    return TextField(
      style: TextStyle(color: navy),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black26),
        suffixIcon: Icon(Icons.search, color: navy, size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: navy, width: 2),
        ),
      ),
    );
  }
}

class _DropdownFilterButton extends StatelessWidget {
  final String title;
  const _DropdownFilterButton({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color navy = Color(0xFF0C2340);
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: navy),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: navy, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 5),
          Icon(Icons.arrow_drop_down, color: navy, size: 24),
        ],
      ),
    );
  }
}
