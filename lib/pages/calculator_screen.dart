import 'package:flutter/material.dart';

import 'button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          //output
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty?
                  "0":
                  "$number1$operand$number2",
                  style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,),
              ),
            ),
          ),
          //buttons
          Wrap(
            children: Btn.buttonValues.map(
                  (value) => SizedBox(
                    width: value==Btn.n0?
                    screenSize.width/2
                        : (screenSize.width/4),
                    height: screenSize.width/5,
                    child: buildButton(value),
                  ),
            ).toList(),
          )
        ],),
      ),
    );
  }
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value,style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value){
    if(value==Btn.del){
      delete();
      return;
    }
    if(value==Btn.clr){
      clearAll();
      return;
    }
    if(value==Btn.per){
      convertPercentage();
      return;
    }
    if(value==Btn.calculate){
      calculate();
      return;
    }

    appendValue(value);
  }
  //calculate the result
  void calculate(){
    if(number1.isEmpty)return;
    if(operand.isEmpty)return;
    if(number2.isEmpty)return;

    final double num1=double.parse(number1);
    final double num2=double.parse(number2);

    var result=0.0;

    switch(operand){
      case(Btn.add):
        result=num1+num2;
        break;
      case(Btn.subtract):
        result=num1-num2;
        break;
      case(Btn.multiply):
        result=num1*num2;
        break;
      case(Btn.divide):
        result=num1/num2;
        break;
      default:
    }

    setState(() {
      number1="$result";

      if(number1.endsWith(".0")){
        //here if the result is like 2.0 then no need to show .0
        number1=number1.substring(0, number1.length-2);
      }
      // we keep our output in number1 because it helps the user to keep calculating
      // like using operands again in the output to further calculate
      operand="";
      number2="";
    });
  }
  //convert output to percentage
  void convertPercentage(){
    // example: 234+342
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
    //   CALCULATE BEFORE CONVERSION
    //   if it is a normal expression like 12+23 then first we need to calculate it
    //   before converting into percentage
      calculate();
    }
    if(operand.isNotEmpty){
      //cannot be converted ex:27+
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1="${(number / 100)}";
      operand="";
      number2="";
    });
  }
  //clears all the entered value
  void clearAll(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }

  // delete one from the end
  void delete(){
    if(number2.isNotEmpty){
      //here if our number is like 12342 then this will subtract 1 number
      //and it will be 1234
      number2=number2.substring(0,number2.length -1);
    }else if(operand.isNotEmpty){
      operand="";
    }else if(number1.isNotEmpty){
      //here if our number is like 12342 then this will subtract 1 number
      //and it will be 1234
      number1=number1.substring(0,number1.length -1);
    }

    setState(() {});
  }

  //appends value to the end
  void appendValue( String value){
    // number 1 operand number 2
    // 234        +     2342

    //to check if it is operand and not "."
    if(value!=Btn.dot&&int.tryParse(value)==null){
      //operand clicked
      if(operand.isNotEmpty&&number2.isNotEmpty){
        //   Calculate the equation before assigning new operand
        calculate();
      }
      // commit try
      operand=value;
    }
    //assign value to number 1 variable
    else if(number1.isEmpty || operand.isEmpty){
      // here we don't want to add another dot after a number like 1.2 so | also checking if value is "."
      if(value==Btn.dot&&number1.contains(Btn.dot)) return;
      if(value==Btn.dot&&number1.isEmpty || number1==Btn.dot) {
        // number1="" | "0"
        value="0.";
      }
      number1+=value;
    }
    // assign value to number2 variable
    else if(number2.isEmpty || operand.isNotEmpty){
      // here we don't want to add another dot after a number like 1.2 so | also checking if value is "."
      if(value==Btn.dot&&number2.contains(Btn.dot)) return;
      if(value==Btn.dot&&number2.isEmpty || number2==Btn.dot) {
        // number2="" | "0"
        value="0.";
      }
      number2 +=value;
    }
    setState(() {});
  }

  Color getBtnColor(value){
    return [Btn.del,Btn.clr].contains(value)?Colors.blueGrey:
    [Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)?Colors.orange:Colors.black87;
  }
}
