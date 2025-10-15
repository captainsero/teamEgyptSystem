import 'package:flutter/material.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class VirtualKeyboardExample extends StatefulWidget {
  @override
  _VirtualKeyboardExampleState createState() => _VirtualKeyboardExampleState();
}

class _VirtualKeyboardExampleState extends State<VirtualKeyboardExample> {
  // Text displayed and manipulated by the virtual keyboard
  String text = "";

  // Shift key state to toggle caps
  bool shiftEnabled = false;

  // void _onKeyPress(VirtualKeyboardKey key) {
  //   setState(() {
  //     if (key.keyType == VirtualKeyboardKeyType.String) {
  //       // Add pressed key character, respecting shift state for caps
  //       text += (shiftEnabled ? key.capsText : key.text)!;
  //     } else if (key.keyType == VirtualKeyboardKeyType.Action) {
  //       // Handle action keys: Backspace, Return, Space, Shift
  //       switch (key.action) {
  //         case VirtualKeyboardKeyAction.Backspace:
  //           if (text.isNotEmpty) {
  //             text = text.substring(0, text.length - 1);
  //           }
  //           break;
  //         case VirtualKeyboardKeyAction.Return:
  //           text += '\n';
  //           break;
  //         case VirtualKeyboardKeyAction.Space:
  //           text += key.text!;
  //           break;
  //         case VirtualKeyboardKeyAction.Shift:
  //           shiftEnabled = !shiftEnabled;
  //           break;
  //         case null:
  //           // TODO: Handle this case.
  //           throw UnimplementedError();
  //         case VirtualKeyboardKeyAction.SwithLanguage:
  //           // TODO: Handle this case.
  //           throw UnimplementedError();
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Virtual Keyboard Example')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Text(text, style: TextStyle(fontSize: 24)),
            ),
          ),
          Container(
            color: Colors.deepPurple,
            child: VirtualKeyboard(
              height: 300,
              type: VirtualKeyboardType.Alphanumeric,
              textColor: Colors.white,
              fontSize: 20,
              defaultLayouts: [VirtualKeyboardDefaultLayouts.English],
            ),
          ),
        ],
      ),
    );
  }
}
