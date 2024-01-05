
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider<List<Contact>>((ref) async {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);

  return await selectContactsRepository.getContacts();
});

final selectContactProvider = Provider<SelectContactController>((ref) {
  final selectContactsRepository = ref.watch(selectContactsRepositoryProvider);

  return SelectContactController(ref: ref,selectContactsRepository: selectContactsRepository);
});

class SelectContactController {
  final SelectContactsRepository selectContactsRepository;
final ProviderRef ref;
  SelectContactController( {required this.ref,required this.selectContactsRepository});

void selectContact({required Contact contact,required BuildContext context})  {
    selectContactsRepository.selectContact(context,contact: contact);
}
}