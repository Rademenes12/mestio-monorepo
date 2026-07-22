import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/contacts_cubit.dart';

class ContactsTab extends StatelessWidget {
  const ContactsTab({super.key, this.isAdmin = false});

  final bool isAdmin;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        return switch (state) {
          ContactsInitial() ||
          ContactsLoading() => const Center(child: CircularProgressIndicator()),
          ContactsError(:final errorKey) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                SelectableText(messageForErrorKey(context.l10n, errorKey)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<ContactsCubit>().refresh(),
                  child: Text(context.l10n.retryButtonLabel),
                ),
              ],
            ),
          ),
          ContactsLoaded(:final contacts) => ListView(
            padding: const EdgeInsets.all(AppColors.spacingSm),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.contactsTabTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: AppColors.electricIndigo,
                      ),
                      onPressed: () => _showAddContactDialog(context),
                      tooltip: context.l10n.addContactTooltip,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Administracja
              _contactSection(
                context,
                context.l10n.contactsCategoryAdministration,
                Icons.business,
                contacts.where((c) => c.category == 'administration').toList(),
              ),

              // Służby awaryjne
              _contactSection(
                context,
                context.l10n.contactsCategoryEmergency,
                Icons.emergency,
                contacts.where((c) => c.category == 'emergency').toList(),
              ),

              // Serwis (sprzątanie/konserwacja/hydraulik/elektryk – wszystko poza ochroną)
              _contactSection(
                context,
                context.l10n.contactsCategoryMaintenance,
                Icons.build,
                contacts.where((c) => c.category == 'maintenance').toList(),
              ),

              // Ochrona – osobna sekcja, oddzielony od Serwisu dla czytelnego UX
              _contactSection(
                context,
                context.l10n.contactsCategorySecurity,
                Icons.shield_outlined,
                contacts.where((c) => c.category == 'security').toList(),
              ),
            ],
          ),
        };
      },
    );
  }

  Widget _contactSection(
    BuildContext context,
    String title,
    IconData icon,
    List<dynamic> contacts,
  ) {
    if (contacts.isEmpty && !isAdmin) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.electricIndigo),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.electricIndigo,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (contacts.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.contact_phone_outlined, size: 48, color: AppColors.azure.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.emptyContactsTitle,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.l10n.emptyContactsBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...contacts.map(
            (contact) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.electricIndigo.withValues(
                    alpha: 0.1,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.electricIndigo,
                  ),
                ),
                title: Text(contact.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.role, style: const TextStyle(fontSize: 12)),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          contact.phone,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => _makePhoneCall(contact.phone),
                      tooltip: context.l10n.callButtonTooltip,
                    ),
                    if (isAdmin)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, contact),
                        tooltip: context.l10n.deleteButton,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final l10n = context.l10n;
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    String selectedCategory = 'administration';

    // Capture the cubit from the current context, since the dialog is built in a
    // separate navigator subtree that does not have access to the BlocProvider.
    final cubit = context.read<ContactsCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.addContactDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.addContactNameLabel,
                    helperText: l10n.addContactNameHelper,
                  ),
                ),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    labelText: l10n.addContactRoleLabel,
                    helperText: l10n.addContactRoleHelper,
                  ),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.addContactPhoneLabel,
                  ),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.addContactEmailLabel,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.addContactCategoryLabel,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'administration',
                      child: Text(l10n.contactsCategoryAdministration),
                    ),
                    DropdownMenuItem(
                      value: 'emergency',
                      child: Text(l10n.contactsCategoryEmergency),
                    ),
                    DropdownMenuItem(
                      value: 'maintenance',
                      child: Text(l10n.contactsCategoryMaintenance),
                    ),
                    DropdownMenuItem(
                      value: 'security',
                      child: Text(l10n.contactsCategorySecurity),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategory = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.addContactCancelButton),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  final email = emailController.text.trim();
                  cubit.addContact(
                    name: nameController.text,
                    role: roleController.text,
                    phone: phoneController.text,
                    email: email.isEmpty ? null : email,
                    category: selectedCategory,
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(l10n.addContactAddButton),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic contact) {
    final l10n = context.l10n;
    // Capture the cubit before opening the dialog (separate navigator subtree).
    final cubit = context.read<ContactsCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteContactDialogTitle),
        content: Text(l10n.deleteContactConfirmMessage(contact.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.deleteContact(contact.id);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
  }
}
