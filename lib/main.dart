import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/dropdown.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "simple interest calculator",
      home: simpleCAl(),
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        accentColor: Colors.red,
        brightness: Brightness.dark,
      )));
}

class simpleCAl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _simpleForm();
  }
}

class _simpleForm extends State<simpleCAl> {
  var _formkey = GlobalKey<FormState>();
  var _currencies = ["Rupees", "Dollor", "Pound"];
  final _minimumPadding = 5.0;
  var _currenSelectItem = "Rupees";
  TextEditingController principalControllar = TextEditingController();
  TextEditingController RateofController = TextEditingController();
  TextEditingController termControlaller = TextEditingController();
  var displayText = "";

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),

      ///Input code:
      body: Form(
        key: _formkey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImages(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      style: textStyle,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9 .]"))
                      ],
                      controller: principalControllar,
                      validator: (String values) {
                        if (values.isEmpty) {
                          return "please enter principal amount";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Principal",
                          hintText: "Enter  e.g 12000",
                          labelStyle: textStyle,
                          errorStyle:
                              TextStyle(color: Colors.amber, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[0-9 .]"))
                      ],
                      style: textStyle,
                      controller: RateofController,
                      validator: (String values) {
                        if (values.isEmpty) {
                          return "please enter rate of interest";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Rate of Interest",
                          hintText: "In Percent",
                          labelStyle: textStyle,
                          errorStyle:
                              TextStyle(color: Colors.amber, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          style: textStyle,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            WhitelistingTextInputFormatter(RegExp("[0-9 .]"))
                          ],
                          controller: termControlaller,
                          validator: (String values) {
                            if (values.isEmpty) {
                              return "please enter Term";
                            }
                          },
                          decoration: InputDecoration(
                              labelText: "Term",
                              hintText: "Time in year",
                              labelStyle: textStyle,
                              errorStyle: TextStyle(
                                  color: Colors.amber, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton(
                          dropdownColor: Colors.redAccent,
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0),
                              ),
                            );
                          }).toList(),
                          value: _currenSelectItem,
                          onChanged: (String newValue) {
                            //your code to execute , when a menu item is selected from dropdown
                            _onDropdropitemslected(newValue);
                          },
                        ))
                      ],
                    )),

                /// calculate and reset button code:
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            "Calculate",
                            textScaleFactor: 1.5,
                          ),
                          elevation: 8.0,
                          onPressed: () {
                            setState(() {
                              if (_formkey.currentState.validate()) {
                                this.displayText = _calculateTotal();
                              }
                            });
                          },
                        )),
                        Expanded(
                            child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          textColor: Theme.of(context).primaryColorDark,
                          child: Text(
                            "Reset",
                            textScaleFactor: 1.5,
                          ),
                          elevation: 8.0,
                          onPressed: () {
                            setState(() {
                              _reset();
                            });
                          },
                        ))
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.all(_minimumPadding * 2),
                  child: Text(
                    this.displayText,
                    style: textStyle,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getImages() {
    AssetImage assetImage = AssetImage("image/currencies.png");
    Image image = Image(
      image: assetImage,
      width: 130.0,
      height: 130.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 6),
    );
  }

  ///drop down menu selector
  void _onDropdropitemslected(String newValue) {
    setState(() {
      this._currenSelectItem = newValue;
    });
  }

  ///calculate
  String _calculateTotal() {
    double principal = double.parse(principalControllar.text);
    double rate = double.parse(RateofController.text);
    double term = double.parse(termControlaller.text);

    double totalamountpay = principal + (principal * rate * term) / 100;
    String result = "after $term years , your investment will"
        " be worth $totalamountpay $_currenSelectItem";
    return result;
  }

  void _reset() {
    principalControllar.text = "";
    RateofController.text = "";
    termControlaller.text = "";
    displayText = "";
    _currenSelectItem = _currencies[0];
  }
}
