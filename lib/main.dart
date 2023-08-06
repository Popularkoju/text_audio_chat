import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_audio_chat/features/chat_screen/chat_screen.dart';
import 'package:text_audio_chat/features/chat_screen/providers/chat%20_state_manager.dart';
import 'package:text_audio_chat/features/chat_screen/providers/voice_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatStateManage()),
        ChangeNotifierProvider(create: (_) => VoiceState())
      ],
      child: MaterialApp(
        title: 'Chat audio demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
