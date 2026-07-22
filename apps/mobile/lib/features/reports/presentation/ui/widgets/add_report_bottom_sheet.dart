import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/l10n.dart';
import '../../../utils/image_compress_utils.dart';

class AddReportBottomSheetContent extends StatefulWidget {
  final Future<void> Function(
    String title,
    String description,
    String category,
    List<String> photoPaths,
    String? pdfPath,
    String? additionalInfo,
    bool isPriority,
  )
  onReportSubmitted;
  final String userRole;
  final Map<String, String?>? prefillData;

  const AddReportBottomSheetContent({
    super.key,
    required this.onReportSubmitted,
    required this.userRole,
    this.prefillData,
  });

  @override
  State<AddReportBottomSheetContent> createState() =>
      _AddReportBottomSheetContentState();
}

class CategoryItem {
  final IconData icon;
  final String name;

  const CategoryItem(this.icon, this.name);
}

class _AddReportBottomSheetContentState
    extends State<AddReportBottomSheetContent> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _additionalInfoController = TextEditingController();

  late String _selectedCategory;
  final List<ImageCompressResult> _selectedPhotos = [];
  String? _selectedPdfPath;
  bool _isPriorityUrgent = false;
  String? _validationErrorKey;

  bool get _canTogglePriority =>
      widget.userRole == 'Zarząd' ||
      widget.userRole == 'Administrator' ||
      widget.userRole == 'Ochrona';

  List<CategoryItem> _categories(AppLocalizations l10n) {
    if (widget.userRole == 'Ochrona') {
      return [
        CategoryItem(
          Icons.admin_panel_settings,
          l10n.reportCategoryZarzadAdministrator,
        ),
        CategoryItem(Icons.build, l10n.reportRecipientBoardAdminService),
      ];
    }
    if (widget.userRole == 'Serwisant') {
      return [
        CategoryItem(
          Icons.admin_panel_settings,
          l10n.reportCategoryZarzadAdministrator,
        ),
        CategoryItem(Icons.security, l10n.reportRecipientBoardAdminSecurity),
      ];
    }
    return [
      CategoryItem(Icons.water_drop, l10n.reportCategoryHydraulika),
      CategoryItem(Icons.bolt, l10n.reportCategoryElektryka),
      CategoryItem(Icons.elevator, l10n.reportCategoryWinda),
      CategoryItem(Icons.local_fire_department, l10n.reportCategoryOgrzewanie),
      CategoryItem(Icons.door_front_door, l10n.reportCategoryDomofon),
      CategoryItem(Icons.lightbulb_outline, l10n.reportCategoryOswietlenie),
      CategoryItem(Icons.local_parking, l10n.reportCategoryParking),
      CategoryItem(Icons.garage, l10n.reportCategoryGaraz),
      CategoryItem(Icons.roofing, l10n.reportCategoryDachElewacja),
      CategoryItem(Icons.cleaning_services, l10n.reportCategorySprzatanie),
      CategoryItem(Icons.park, l10n.reportCategoryZielen),
      CategoryItem(
        Icons.admin_panel_settings,
        l10n.reportCategoryZarzadAdministrator,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedCategory = '';
    final prefill = widget.prefillData;
    if (prefill != null) {
      final parts = <String>[];
      if (prefill['building'] != null && prefill['building']!.isNotEmpty) {
        parts.add('${context.l10n.buildingLabel}: ${prefill['building']}');
      }
      if (prefill['stairwell'] != null && prefill['stairwell']!.isNotEmpty) {
        parts.add('${context.l10n.stairwellLabel}: ${prefill['stairwell']}');
      }
      if (prefill['floor'] != null && prefill['floor']!.isNotEmpty) {
        parts.add('${context.l10n.floorLabel}: ${prefill['floor']}');
      }
      if (prefill['apartment'] != null && prefill['apartment']!.isNotEmpty) {
        parts.add('${context.l10n.apartmentLabel}: ${prefill['apartment']}');
      }
      if (parts.isNotEmpty) {
        _descriptionController.text =
            '${context.l10n.qrLocationPrefix}\n${parts.join('\n')}\n\n';
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedCategory.isEmpty) {
      _selectedCategory = _categories(context.l10n).first.name;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _selectedPdfPath = result.files.single.path);
      }
    } catch (e) {
      debugPrint('\u274c [AddReport] PDF pick failed: $e');
    }
  }

  Future<void> _pickAndCompress(ImageSource source) async {
    final picker = ImagePicker();
    final result = await ImageCompressUtils.pickAndCompressImage(
      picker: picker,
      source: source,
    );

    if (result != null) {
      setState(() => _selectedPhotos.add(result));
    }
  }

  void _removePhotoAt(int index) {
    setState(() => _selectedPhotos.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppColors.spacingSm,
        AppColors.spacingSm,
        AppColors.spacingSm,
        AppColors.spacingSm + mediaQuery.viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle & Title
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.reportComposerTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Form Fields
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.reportTitleHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descriptionController,
              maxLines: 5,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
              hintText: l10n.reportDescriptionHint,
                hintMaxLines: 3,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory.isEmpty
                  ? null
                  : _selectedCategory,
              decoration: InputDecoration(
                labelText: l10n.reportCategoryLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _categories(l10n).map((cat) {
                return DropdownMenuItem(
                  value: cat.name,
                  child: Row(
                    children: [
                      Icon(cat.icon, size: 18, color: AppColors.electricIndigo),
                      const SizedBox(width: 12),
                      Text(cat.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Photo picker
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickAndCompress(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: Text(
                      _selectedPhotos.isEmpty
                          ? l10n.photoTakePhotoButton
                          : l10n.photoAddMoreButton,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickAndCompress(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: Text(l10n.photoGalleryButton),
                  ),
                ),
              ],
            ),

            if (_selectedPhotos.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                l10n.photosSelectedCount(_selectedPhotos.length),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedPhotos.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final photo = _selectedPhotos[index];
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(photo.path),
                            width: 72,
                            height: 72,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -7,
                          right: -7,
                          child: GestureDetector(
                            onTap: () => _removePhotoAt(index),
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: AppColors.crimsonCoral,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 12),

            // PDF attachment picker
            OutlinedButton.icon(
              onPressed: _pickPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: Text(
                _selectedPdfPath != null ? l10n.pdfSelectedLabel : l10n.pdfAttachButton,
                style: const TextStyle(fontSize: 12),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _selectedPdfPath != null
                    ? Colors.green
                    : AppColors.lightTextSecondary,
                side: BorderSide(
                  color: _selectedPdfPath != null
                      ? Colors.green
                      : AppColors.lightBorder,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Free-text note for the board
            Text(
              context.l10n.additionalInfoLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.lightTextSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _additionalInfoController,
              decoration: InputDecoration(
                hintText: context.l10n.additionalInfoHint,
                isDense: true,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              style: const TextStyle(fontSize: 13),
              maxLines: 2,
            ),

            if (_canTogglePriority) ...[
              const SizedBox(height: 14),
              InkWell(
                onTap: () =>
                    setState(() => _isPriorityUrgent = !_isPriorityUrgent),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _isPriorityUrgent
                        ? AppColors.amber.withValues(alpha: 0.12)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isPriorityUrgent
                          ? AppColors.amber
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.priority_high,
                        size: 18,
                        color: Color(0xFFC98800),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          context.l10n.markAsUrgentLabel,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isPriorityUrgent,
                        activeThumbColor: AppColors.amber,
                        onChanged: (v) => setState(() => _isPriorityUrgent = v),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_validationErrorKey == 'reportTitleRequired') ...[
              const SizedBox(height: 12),
              SelectableText(
                context.l10n.reportTitleRequiredSnackbar,
                style: const TextStyle(color: AppColors.crimsonCoral, fontSize: 12),
              ),
            ],

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final desc = _descriptionController.text.trim();
                if (title.isEmpty) {
                  setState(() => _validationErrorKey = 'reportTitleRequired');
                  return;
                }
                if (_validationErrorKey != null) {
                  setState(() => _validationErrorKey = null);
                }
                if (mounted) {
                  Navigator.pop(context);
                }
                await widget.onReportSubmitted(
                  title,
                  desc,
                  _selectedCategory,
                  _selectedPhotos.map((p) => p.path).toList(),
                  _selectedPdfPath,
                  _additionalInfoController.text.trim(),
                  _isPriorityUrgent,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricIndigo,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.submitReportButton,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
