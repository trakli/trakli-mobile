import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/forms/add_category_form.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddCategoryScreen extends StatefulWidget {
  final CategoryEntity? category;
  final TransactionType type;
  final Color? accentColor;

  const AddCategoryScreen({
    super.key,
    this.category,
    this.accentColor,
    required this.type,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(
        title: widget.category != null
            ? LocaleKeys.editCategory.tr()
            : LocaleKeys.addCategory.tr(),
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listenWhen: (previous, current) =>
            previous.isSaving != current.isSaving,
        listener: (context, state) {
          if (state.failure.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.maybeMap(
                  orElse: () => state.failure.customMessage,
                  duplicate: (failure) =>
                      LocaleKeys.categoryNameAlreadyExists.tr(),
                )),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (!state.isSaving && !state.failure.hasError) {
            AppNavigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: AddCategoryForm(
            category: widget.category,
            type: widget.type,
            accentColor: widget.accentColor ?? const Color(0xFFEB5757),
            onSubmit: ({
              required description,
              icon,
              mediaEntity,
              required name,
              required type,
            }) {
              hideKeyBoard();
              if (widget.category != null) {
                context.read<CategoryCubit>().updateCategory(
                      clientId: widget.category!.clientId,
                      name: name,
                      slug: _generateSlug(name),
                      description: description,
                      media: mediaEntity,
                    );
              } else {
                context.read<CategoryCubit>().addCategory(
                      name: name,
                      slug: _generateSlug(name),
                      type: widget.type,
                      description: description,
                      media: mediaEntity,
                    );
              }
            },
          ),
        ),
      ),
    );
  }
}
