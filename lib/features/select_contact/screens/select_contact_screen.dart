import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/select_contact_controller.dart';


class SelectContactScreen extends ConsumerWidget {
  static const routeName = '/select-contact';
  const SelectContactScreen({super.key});
void selectContact({required Contact contact,required BuildContext context,required WidgetRef ref}) {
  final selectContactController = ref.read(selectContactProvider);
  selectContactController.selectContact(context: context, contact: contact);
}
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
        data: (contacts) {
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                onTap: () {
            selectContact(contact: contact,context: context,ref: ref);
                },
                leading: CircleAvatar(
backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,

                ),
                title: Text(contact.displayName ?? ''),
                // subtitle: Text(contact. ?? ''),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => ErrorWidget(err),
      ),
    );
  }
}