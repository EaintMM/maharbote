import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedDate = DateTime.now();
  var selected = false;
  var f = DateFormat("dd/MM/yyyy EEEE");

  var modVal = 0;
  var houseName = "";

  var numList = [1, 4, 0, 3, 6, 2, 5];
 
  // checkbox
  var isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maharbote"),
        elevation: 10,
      ),
      body: _homeDesign(),
    );
  }

  // customized maharbote layout widget
  Widget _mahaboteLayout() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(""),
                _labelText("အဓိပတိ"),
                Text(""),
              ],
            ),
            //2nd row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labelText("အထွန်း"),
                _labelText("သိုက်"),
                _labelText("ရာဇ"),
              ],
            ),
            // 3rd row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _labelText("မရဏ"),
                _labelText("ဘင်္ဂ"),
                _labelText("ပုတိ"),
              ],
            ),
          ],
        ),
      );

  // customized number list layout widget
  Widget _numberLayout() => Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(""),
                _numText("${numList[6]}"),
                Text(""),
              ],
            ),
            //2nd row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _numText("${numList[2]}"),
                _numText("${numList[3]}"),
                _numText("${numList[4]}"),
              ],
            ),
            // 3rd row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _numText("${numList[1]}"),
                _numText("${numList[0]}"),
                _numText("${numList[5]}"),
              ],
            ),
          ],
        ),
      );
// house calculation
  String _houseResult(year, day) {
    var houses = ["ဘင်္ဂ", "အထွန်း", "ရာဇ", "အဓိပတိ", "မရဏ", "သိုက်", "ပုတိ"];
    return houses[(year - day - 1) % 7];
  }

// change state upon selected date
  void _changeState(DateTime picked, var myanmarYear) {
    setState(() {
      selectedDate = picked;
      modVal = myanmarYear % 7;
      //print(myanmarYear);
      print(picked.weekday);
      _updateList(modVal);
      houseName = _houseResult(myanmarYear, picked.weekday);
      selected = true;
    });
  }

  // update list
  void _updateList(int mod) {
    var temp = numList.sublist(numList.indexOf(mod), numList.length);
    temp.addAll(numList.sublist(0, numList.indexOf(mod)));
    setState(() {
      numList = temp;
    });
  }

  // color changing
  TextStyle _selectedColor(chosenVal, val) => TextStyle(
      color: chosenVal == val ? Theme.of(context).primaryColor : Colors.black);

  // custom text
  Text _labelText(val) => Text(
        val,
        style: _selectedColor(houseName, val),
      );

  // custom text for number
  Text _numText(val) {
    var day = (selectedDate.weekday + 1) % 7;
    print("day is $day");
    print("vale is $val");
    return Text(val, style: _selectedColor(day.toString(), val));
  }

  Widget _homeDesign() => ListView(children: <Widget>[
        Container(
            height: 100,
            color: Theme.of(context).colorScheme.primary,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(1880),
                    lastDate: DateTime(2025),
                    helpText: "Select your birthday.",
                    cancelText: "Not Now",
                  );
                  if (picked != null) {
                    var myanmarYear = picked.year - 638;
                    if (picked.month < 4) {
                      myanmarYear = picked.year - 639;
                    }
                    _changeState(picked, myanmarYear);
                  }
                },
                child: selected
                    ? Text("Your selected date ${f.format(selectedDate)}")
                    : const Text("Enter your birthday."),
              ),
            )),
        // checkbox
        selectedDate.month != 4
            ? Container()
            : Container(
                child: Center(
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  var myanmarYear = 0;
                                  if (isChecked) {
                                    myanmarYear = selectedDate.year - 639;
                                  } else {
                                    myanmarYear = selectedDate.year - 638;
                                  }
                                  _changeState(selectedDate, myanmarYear);
                                });
                              }),
                          const Text("ဧပြီ လ မြန်မာနှစ်ဟောင်းတွင် မွေးသည်။"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

        Container(
          height: 110,
          margin: EdgeInsets.all(8),
          child: Center(
            child: Card(
              child: Center(
                child: _mahaboteLayout(),
              ),
            ),
          ),
        ),
        selected == false
            ? Container()
            : Container(
                margin: EdgeInsets.all(8),
                child: Card(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text("အကြွင်း $modVal"),
                      Text(
                        houseName,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                )),
              ),
        selected == false?
        Container():
        Container(
          margin: EdgeInsets.all(8),
          child: Center(
            child: Card(
              child: Center(
                child: _numberLayout(),
              ),
            ),
          ),
        ),
      ]);
}
