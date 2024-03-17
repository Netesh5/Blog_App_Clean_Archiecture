import 'dart:io';

import 'package:clean_arch_application/core/constants/app_string.dart';
import 'package:clean_arch_application/core/cubits/app_user/app_user_cubit.dart';
import 'package:clean_arch_application/core/theme/app_pallete.dart';
import 'package:clean_arch_application/features/homepage/presentation/widgets/blog_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  // void selectImage() async {
  //   final pickedImage = await pickImage();
  //   if (pickedImage != null) {
  //     setState(() {
  //       image = pickedImage;
  //     });
  //   }
  // }

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.uid;
      // context.read<BlogBloc>().add(
      //       BlogUpload(
      //         posterId: posterId,
      //         title: titleController.text.trim(),
      //         content: contentController.text.trim(),
      //         image: image!,
      //         topics: selectedTopics,
      //       ),
      //     );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                image != null
                    ? GestureDetector(
                        // onTap: selectImage,
                        child: SizedBox(
                          width: double.infinity,
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          // selectImage();
                        },
                        child: DottedBorder(
                          color: AppPallete.borderColor,
                          dashPattern: const [10, 4],
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          strokeCap: StrokeCap.round,
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Select your image',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppString.contentType
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedTopics.contains(e)) {
                                  selectedTopics.remove(e);
                                } else {
                                  selectedTopics.add(e);
                                }
                                setState(() {});
                              },
                              child: Chip(
                                label: Text(
                                  e,
                                  style: TextStyle(
                                    color: selectedTopics.contains(e)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: selectedTopics.contains(e)
                                    ? const MaterialStatePropertyAll(
                                        AppPallete.successColor,
                                      )
                                    : null,
                                side: selectedTopics.contains(e)
                                    ? null
                                    : const BorderSide(
                                        color: AppPallete.borderColor,
                                      ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                BlogTextField(
                  controller: titleController,
                  hintText: 'Blog title',
                ),
                const SizedBox(height: 10),
                BlogTextField(
                  controller: contentController,
                  hintText: 'Blog content',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
