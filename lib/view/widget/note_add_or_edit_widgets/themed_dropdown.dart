import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/add_or_edit_note_controller.dart';
import '../../../localization/l10n.dart';
import '../../../models/category.dart';

class ThemedDropdown extends StatelessWidget {
  final AddOrEditNoteController controller = Get.find();

  ThemedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    print('this is the default selected item: ${controller.selectedCategory.value?.name??'null'}');
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          width: 1.0,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          dropdownColor: Get.theme.colorScheme.background,
          value: controller.selectedCategoryNullable(),
          items: controller.categories.map((Category category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Container(
                height: 60,
                width: Get.width,
                decoration: BoxDecoration(
                  // color: controller.inv,
                  // category.color??Colors.transparent
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.name.tr,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    if (category.imageUrl != null)
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          category.imageUrl!,
                          color: category.color,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (Category? newValue) {
            controller.updateSelectedCategory(newValue);
          },
          hint: Text(
            L10n.selectCategory.tr,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).hintColor),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          isExpanded: true,
          borderRadius: BorderRadius.circular(10.0),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ));
  }
}
