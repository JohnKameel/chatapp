import 'package:chat_app/core/database/database_service.dart';
import 'package:chat_app/core/database/supabase_service.dart';
import 'package:chat_app/features/auth/data/repo/auth_repo.dart';
import 'package:chat_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:chat_app/features/auth/presentation/viewModel/auth_cubit.dart';
import 'package:chat_app/features/contacts/data/repo/contact_repo.dart';
import 'package:chat_app/features/contacts/data/repo/contact_repo_impl.dart';
import 'package:chat_app/features/contacts/presentation/viewModel/contacts_cubit.dart';
import 'package:chat_app/features/home/data/repo/home_repo.dart';
import 'package:chat_app/features/home/presentation/viewModel/room_cubit.dart';
import 'package:chat_app/features/profile/data/repo/profile_repo.dart';
import 'package:chat_app/features/profile/data/repo/profile_repo_impl.dart';
import 'package:chat_app/features/profile/presentation/viewModel/profile_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
// frame call back

void setupServiceLocator() {
  // database
  getIt.registerSingleton<DatabaseService>(SupabaseService());
  // repo
  getIt.registerSingleton<AuthRepo>(AuthRepoImpl(getIt.get<DatabaseService>()));
  getIt.registerSingleton<ContactRepo>(ContactRepoImpl(getIt.get<DatabaseService>()));
  getIt.registerSingleton<ProfileRepo>(ProfileRepoImpl(getIt.get<DatabaseService>()));
  getIt.registerSingleton<HomeRepo>(HomeRepo(getIt.get<DatabaseService>()));

  // cubit
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt.get<AuthRepo>()));
  getIt.registerFactory<ContactsCubit>(() => ContactsCubit(getIt.get<ContactRepo>()));
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt.get<ProfileRepo>()));
  getIt.registerFactory<RoomCubit>(() => RoomCubit(getIt.get<HomeRepo>()));

}