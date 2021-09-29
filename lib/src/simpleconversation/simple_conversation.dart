import 'package:flutter/material.dart';
import 'package:fsse/src/engine/fsse_engine.dart';

class SimpleConversation extends StatefulWidget {
  const SimpleConversation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SimpleConversationState();
}

class SimpleConversationState extends State<SimpleConversation> {
  @override
  Widget build(BuildContext context) {
    return (MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("FSSE Sample"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: MaterialButton(
            child: const Text("Proceed"),
            onPressed: () async {
              final loader = AssetEngineLoader();
              final engine = RealFsseEngine(loader);

              final firstItem = await engine.proceed();

              print("Successfully load the engine!");
              print(firstItem);
            },
          ),
        ),
      ),
    ));
  }
}
