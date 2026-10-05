import QtQuick
import QtQuick.Controls
ApplicationWindow{
 palette.windowText: "white"; palette.text: "white"; palette.buttonText: "white"; palette.brightText: "white"; palette.highlightedText: "white"; palette.placeholderText: "white"visible:true;width:500;height:650;title:"WINUX11 Calculator";color:"#090b10"
 Column{anchors.fill:parent;anchors.margins:18;spacing:10
  TextField{id:expr;width:parent.width;height:70;font.pixelSize:28;color:"white";placeholderText:"0 + 2 * 3";onAccepted:result.text=calculator.evaluate(text)}
  Label{id:result;text:"0";width:parent.width;font.pixelSize:40;color:"white";horizontalAlignment:Text.AlignRight}
  Grid{columns:4;spacing:8
   Repeater{model:["7","8","9","/","4","5","6","*","1","2","3","-","0",".","(",")","+","C","="];delegate:Button{width:105;height:58;text:modelData;font.pixelSize:20;onClicked:{if(text==="C")expr.text="";else if(text==="=")result.text=calculator.evaluate(expr.text);else expr.text+=text}}}
  }
 }
}
