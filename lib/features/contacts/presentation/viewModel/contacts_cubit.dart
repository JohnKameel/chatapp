import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/data/model/user_info_model.dart';
import 'package:chat_app/features/contacts/data/repo/contact_repo.dart';
import 'package:meta/meta.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactRepo contactRepo;
  ContactsCubit(this.contactRepo) : super(ContactsInitial());

  fetchContacts() async {
    emit(ContactsLoading());
    final result = await contactRepo.getAllContacts();

    result.fold(
      (failure) => emit(ContactsFailure(failure.message)),
      (contacts) => emit(ContactsSuccess(contacts)),
    );
  }
}
