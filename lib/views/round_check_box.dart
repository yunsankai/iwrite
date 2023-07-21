import 'package:flutter/material.dart';

class RoundCheckBox extends StatefulWidget {
  final bool value;

  final ValueChanged<bool>? onChanged;

  final Widget unSelectChild;
  final Widget selectChild;
  late final bool? userInterfaceEnable;
  RoundCheckBox({Key? key, required this.value, this.onChanged, required this.unSelectChild, required this.selectChild, this.userInterfaceEnable})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  late bool _value;
  late ValueChanged<bool>? _onChanged;

  @override
  void initState() {
    super.initState();

  }

  ///   value: _throwShotAway,
  ///   onChanged: (bool newValue) {
  ///     setState(() {
  ///       _throwShotAway = newValue;
  ///     });
  ///   },

  @override
  Widget build(BuildContext context) {
    _value = widget.value;
    _onChanged = widget.onChanged;
    widget.userInterfaceEnable ??= true;
    return Center(
      child: GestureDetector(
          onTap: widget.userInterfaceEnable != false ? () {
            _value = !_value;
            if(_onChanged != null){
              _onChanged!(_value);
            }
          } : null,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: _value
                ? widget.selectChild
                : widget.unSelectChild,
          )),
    );
  }
}