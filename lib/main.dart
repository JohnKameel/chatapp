import 'package:chat_app/core/routing/router_app.dart';
import 'package:chat_app/features/contacts/presentation/viewModel/contacts_cubit.dart';
import 'package:chat_app/features/home/presentation/viewModel/room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/server_locator/server_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  // Initialize supabase
  await Supabase.initialize(
    url: 'https://dfqowngfjapvutiilxbk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmcW93bmdmamFwdnV0aWlseGJrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3OTE0NDAsImV4cCI6MjA2NjM2NzQ0MH0.16jJVWZNhLFgO6zI0YWHCLw1qITbDRHdW4pNGohfSfg',
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ContactsCubit>(
        create: (context) => getIt<ContactsCubit>()..fetchContacts(),
      ),
      BlocProvider<RoomCubit>(
        create: (context) => getIt<RoomCubit>()..getAllRooms(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: RouterApp.goRouter,
          debugShowCheckedModeBanner: false,
          title: 'Chat App',
        );
      },
    );
  }
}
