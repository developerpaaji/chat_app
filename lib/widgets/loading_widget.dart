import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final Function onDisposed;
  final Function onInit;
  const LoadingWidget({Key key, this.onDisposed, this.onInit}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();

}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }
  @override
  Widget build(BuildContext context) {
    print("Start Loading");
    return Center(child: CircularProgressIndicator());
  }
  @override
  void dispose() {
    widget.onDisposed();
    super.dispose();
  }
}