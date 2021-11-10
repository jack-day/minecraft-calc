import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database.dart';

class MinecraftCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minecraft Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontSize: 30),
          button: TextStyle(fontSize: 20),
        ),
      ),
      home: Calculator(),
    );
  }
}


class Calculator extends StatelessWidget {
  /*-------------------------------------
  UI
  --------------------------------------*/
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CalculatorState>(context);

    return Scaffold(
      appBar: AppBar(
          title: const Text("Minecraft Energy Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: ListView (
            children: <Widget>[
              /*-------------------------------------
              From Input
              --------------------------------------*/
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 30),
                      decoration: InputDecoration(
                        labelText: 'From',
                        contentPadding: EdgeInsets.all (10.0)
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: state.fromChange,
                      controller: state.fromController,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => ChangeUnit(
                            data: ChangeUnitData(
                              units: state.units,
                              currentUnit: state.fromUnit,
                              setUnit: state.setFromUnit
                            )
                          )
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.black)
                        ),
                      ),
                      child: Consumer<CalculatorState>(
                        builder: (context, state, child) {
                          return Text('${state.fromUnit}', style: TextStyle(color: Colors.white));
                        }
                      ),
                    ),
                  )
                ],
              ),
              /*-------------------------------------
              Swap Units
              --------------------------------------*/
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container()
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: () => state.swapUnits(),
                      child: Image.asset(
                        'assets/images/swap-units.png',
                        semanticLabel: 'Swap Units',
                        width: 50,
                      ),
                    )
                  )
                ],
              ),
              /*-------------------------------------
              To Input
              --------------------------------------*/
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 30),
                      decoration: InputDecoration(
                        labelText: 'To',
                        contentPadding: EdgeInsets.all (10.0)
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: state.toChange,
                      controller: state.toController,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => ChangeUnit(
                            data: ChangeUnitData(
                              units: state.units,
                              currentUnit: state.toUnit,
                              setUnit: state.setToUnit
                            )
                          )
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.black)
                        ),
                      ),
                      child: Consumer<CalculatorState>(
                        builder: (context, state, child) {
                          return Text('${state.toUnit}', style: TextStyle(color: Colors.white));
                        }
                      ),
                    ),
                  )
                ],
              ),
              /*-------------------------------------
              Save Result
              --------------------------------------*/
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(15.0),
                    onPressed: state.saveResult,
                    child: Text('Save Result'),
                  ),
                ),
              ),
              /*-------------------------------------
              Show Saved Results
              --------------------------------------*/
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: FlatButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(15.0),
                    onPressed: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => SavedResults()
                        ),
                      );
                    },
                    child: Text('Show Saved Results'),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}


/*-------------------------------------
Units Screen
--------------------------------------*/
class ChangeUnitData {
  List<String> units;
  String currentUnit;
  void Function(String) setUnit;

  ChangeUnitData({this.units, this.currentUnit, this.setUnit});
}

class ChangeUnit extends StatelessWidget {
  final ChangeUnitData data;
  ChangeUnit({this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Unit')
      ),
      body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        data.setUnit(data.units[index]);
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            data.units[index],
                            style: TextStyle(color: (data.units[index] == data.currentUnit) ? Colors.white : Colors.black)
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: (data.units[index] == data.currentUnit) ? Theme.of(context).primaryColor : Color(0xFFeeeeee),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        )
                      ),
                    );
                  },
                  childCount: data.units.length
                ),
              )
            )
          ]
      ),
    );
  }
}


/*-------------------------------------
Saved Results
--------------------------------------*/
class SavedResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Results')
      ),
      body: FutureBuilder<List<Calc>>(
        future: DatabaseProvider.instance.getCalcs(),
        builder: (BuildContext context, AsyncSnapshot<List<Calc>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].toString()),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          } else {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}



/*-------------------------------------
State
--------------------------------------*/
class CalculatorState extends ChangeNotifier {
  /*-------------------------------------
  Data
  --------------------------------------*/
  Map<String, double> cvr = {
    'J': 1,
    'EU': 0.1,
    'FE': 0.4,
    'gJ': 0.655,
    'MJ': 0.04,
    'RF': 0.4,
    'T': 0.4,
    'µI': 0.4,
    'IF': 0.4
  };

  List<String> units = ['J', 'EU', 'FE', 'gJ', 'MJ', 'RF', 'T', 'µI', 'IF'];

  int from = 0;
  int to = 0;
  String fromUnit = 'J';
  String toUnit = 'J';

  final fromController = TextEditingController();
  final toController = TextEditingController();


  /*-------------------------------------
  Notify Listeners
  --------------------------------------*/
  @override
  void notifyListeners() {
    if (fromController.text != from.toString()) fromController.text = from.toString() ?? 0;
    if (toController.text != to.toString()) toController.text = to.toString() ?? 0;
    super.notifyListeners();
  }


  /*-------------------------------------
  Input Change
  --------------------------------------*/
  void fromChange(String input) {
    from = int.parse(input);
    convertFrom();
  }

  void toChange(String input) {
    to = int.parse(input);
    convertTo();
  }


  /*-------------------------------------
  Conversion
  --------------------------------------*/
  void convertFrom() {
    double baseValue = from / cvr[fromUnit];
    double converted = baseValue * cvr[toUnit];
    to = converted.round();
    notifyListeners();
  }

  void convertTo() {
    double baseValue = to / cvr[toUnit];
    double converted = baseValue * cvr[fromUnit];
    from = converted.round();
    notifyListeners();
  }


  /*-------------------------------------
  Setting Units
  --------------------------------------*/
  void setFromUnit(String unit) {
    if (units.contains(unit)) {
      fromUnit = unit;
      convertFrom();
    }
  }

  void setToUnit(String unit) {
    if (units.contains(unit)) {
      toUnit = unit;
      convertFrom();
    }
  }

  void swapUnits() {
    int tmp = from;
    from = to;
    to = tmp;

    String tmpUnit = fromUnit;
    fromUnit = toUnit;
    toUnit = tmpUnit;

    convertFrom();
  }


  /*-------------------------------------
  Database Interactions
  --------------------------------------*/
  void saveResult() async {
    await DatabaseProvider.instance.insertCalc(Calc(
      fromValue: from,
      toValue: to,
      fromUnit: fromUnit,
      toUnit: toUnit,
    ));
  }
}


/*-------
To Do:

Done:
- Figure out how to change TextField value when state has a change
  - Maybe Controller wrapped in Consumer?
- Add Units screen back in using a different class
-Add Database
-Add save result
-Add Show saved results
-Make main content scrollable
*/