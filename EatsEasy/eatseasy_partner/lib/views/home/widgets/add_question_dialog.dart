
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../common/app_style.dart';
import '../../../constants/constants.dart';
import '../../../controllers/foods_controller.dart';
import '../../../models/foods.dart';
import '../../auth/widgets/email_textfield.dart';

class AddQuestionDialog extends StatefulWidget {
  final Function(CustomAdditives) onAdd;
  final CustomAdditives? question;

  const AddQuestionDialog({super.key, required this.onAdd, this.question});
  @override
  _AddQuestionDialogState createState() => _AddQuestionDialogState();
}
class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final foodsController = Get.put(FoodsController());
  TextEditingController _controller = TextEditingController();
  List<TextEditingController> _controllers = [];
  late TextEditingController _selectionNumberController;
  late TextEditingController _customErrorMessageController;
  TextEditingController _minScaleLabelController = TextEditingController();
  TextEditingController _maxScaleLabelController = TextEditingController();

  String? _selectedType;
  List<Options> _options = [];
  double _linearScale = 5.0; // Default value for linear scale
  double _minScale = 1.0; // Default min scale value
  double _maxScale = 10.0; // Default max scale value
  String _selectedMinScale = '1.0';
  String _selectedMaxScale = '5.0';
  bool _isRequired = false;
  String? _selectionType = 'None';

  final List<String> _minScaleOptions = ['0.0', '1.0'];
  final List<String> _maxScaleOptions = ['2.0', '3.0', '4.0', '5.0', '6.0', '7.0', '8.0', '9.0', '10.0'];
  final List<String> _selectionTypeOptions = ['None', 'Select at least:', 'Select at most:', 'Select exactly:'];
  List<String> questionType = ['Multiple Choice', 'Checkbox', 'Short Answer', 'Paragraph', 'Linear Scale'];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question?.text);
    _selectedType = widget.question?.type;
    _options = widget.question?.options ?? [];
    _linearScale = widget.question?.linearScale ?? 5.0;
    _minScale = widget.question?.minScale ?? 1.0;
    _maxScale = widget.question?.maxScale ?? 5.0;
    _selectedMinScale = _minScale.toString();
    _selectedMaxScale = _maxScale.toString();
    _minScaleLabelController = TextEditingController(text: widget.question?.minScaleLabel);
    _maxScaleLabelController = TextEditingController(text: widget.question?.maxScaleLabel);
    _selectionNumberController = TextEditingController(text: widget.question?.selectionNumber?.toString() ?? '');
    _customErrorMessageController = TextEditingController(text: widget.question?.customErrorMessage ?? '');
    _isRequired = widget.question?.required ?? false;
    _selectionType = widget.question?.selectionType ?? _selectionType;

    // Initialize TextEditingControllers for each option
    for (var option in _options) {
      option.optionNameController = TextEditingController(text: option.optionName);
      option.priceController = TextEditingController(text: option.price);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _minScaleLabelController.dispose();
    _maxScaleLabelController.dispose();
    _selectionNumberController.dispose();
    _customErrorMessageController.dispose();

    // Dispose each option's controllers
    for (var option in _options) {
      option.optionNameController?.dispose();
      option.priceController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.question == null ? 'Add custom additive' : 'Edit custom additive', style: appStyle(20, kGray, FontWeight.w600)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EmailTextField(
              hintText: 'Question Text',
              controller: _controller,
              prefixIcon: Icon(
                Ionicons.text,
                color: Theme.of(context).dividerColor,
                size: 20.h,
              ),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 10.h,),
            DropdownFormField(
              hint: const Text("Question type"),
              value: _selectedType,
              items: questionType.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value), // Display "min" in the dropdown
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                  // Clear options when switching question types
                  if (_selectedType != 'Multiple Choice' || _selectedType == 'Checkbox') {
                    _options.clear();
                  }
                });
              },
            ),
            SizedBox(height: 10.h,),
            if (_selectedType == 'Multiple Choice' || _selectedType == 'Checkbox') ...[
              ..._options.asMap().entries.map((entry) {
                int index = entry.key;
                Options option = entry.value;  // Updated to use Options class

                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Option Name Input Field
                      EmailTextField(
                        hintText: 'Option ${index + 1}',
                        textCapitalization: TextCapitalization.sentences,
                        prefixIcon: Icon(
                          Ionicons.options,
                          color: Theme.of(context).dividerColor,
                          size: 20.h,
                        ),
                        onChanged: (value) {
                          setState(() {
                            option.optionName = value;  // Update the option name
                          });
                        },
                        controller: option.optionNameController,
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 8.h), // Space between fields
                      // Price Input Field
                      EmailTextField(
                        hintText: 'Price',
                        prefixIcon: Icon(
                          Ionicons.cash_outline,
                          color: Theme.of(context).dividerColor,
                          size: 20.h,
                        ),
                        onChanged: (value) {
                          setState(() {
                            option.price = value;  // Update the option price
                          });
                        },
                        controller: option.priceController,
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        _options.removeAt(index);
                      });
                    },
                  ),
                );
              }),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    var newOption = Options(optionName: '', price: '');
                    newOption.optionNameController = TextEditingController(text: newOption.optionName);
                    newOption.priceController = TextEditingController(text: newOption.price);
                    _options.add(newOption);
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: kSecondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Add Option",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              if (_selectedType == 'Checkbox') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownFormField(
                        value: _selectionType,
                        items: _selectionTypeOptions.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        )).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectionType = value!;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10.h),
                    if (_selectionTypeOptions.length > 1)
                      Expanded(
                        flex: 1,
                        child: EmailTextField(
                          hintText: 'Number',
                          enabled: _selectionTypeOptions.length > 1 && _selectionType == _selectionTypeOptions[0] ? false : true,
                          controller: _selectionNumberController,
                          keyboardType: TextInputType.number,
                          contentPadding: const EdgeInsets.all(17),
                          textCapitalization: TextCapitalization.none,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                EmailTextField(
                  hintText: 'Custom error message',
                  enabled: _selectionTypeOptions.length > 1 && _selectionType == _selectionTypeOptions[0] ? false : true,
                  controller: _customErrorMessageController,
                  prefixIcon: Icon(
                    Ionicons.text,
                    color: Theme.of(context).dividerColor,
                    size: 20.h,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ],

            SizedBox(height: 10.h,),
            if (_selectedType == 'Linear Scale') ...[
              Row(
                children: [
                  Expanded(
                    child: DropdownFormField(
                      hint: const Text("Min scale"),
                      value: _selectedMinScale,
                      items: _minScaleOptions.map((scale) => DropdownMenuItem(
                        value: scale,
                        child: Text(scale),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMinScale = value!;
                          _minScale = double.tryParse(_selectedMinScale) ?? 2.0;
                          // Ensure maxScale is not less than minScale
                          if (_maxScale < _minScale) {
                            _maxScale = _minScale;
                            _selectedMaxScale = _minScale.toString();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownFormField(
                      hint: const Text("Max scale"),
                      value: _selectedMaxScale,
                      items: _maxScaleOptions.map((scale) => DropdownMenuItem(
                        value: scale,
                        child: Text(scale),
                      )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMaxScale = value!;
                          _maxScale = double.tryParse(_selectedMaxScale) ?? 10.0;
                          // Ensure minScale is not greater than maxScale
                          if (_minScale > _maxScale) {
                            _minScale = _maxScale;
                            _selectedMinScale = _maxScale.toString();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(
                children: [
                  Expanded(
                    child: EmailTextField(
                      hintText: "Min label",
                      controller: _minScaleLabelController,
                      keyboardType: TextInputType.text,
                      contentPadding: const EdgeInsets.all(17),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: EmailTextField(
                      hintText: "Max label",
                      controller: _maxScaleLabelController,
                      keyboardType: TextInputType.text,
                      contentPadding: const EdgeInsets.all(17),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ],
              ),
            ],
            CheckboxListTile(
              title: const Text('Required'),
              value: _isRequired,
              onChanged: (value) {
                setState(() {
                  _isRequired = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              final question = CustomAdditives(
                id: foodsController.generateRandomNumber(),
                text: _controller.text,
                type: _selectedType,
                options: _selectedType == 'Multiple Choice' || _selectedType == 'Checkbox'
                    ? _options // Using _options directly as it's already of type List<Options>
                    : [],
                linearScale: _selectedType == 'Linear Scale' ? _linearScale : null,
                minScale: _selectedType == 'Linear Scale' ? _minScale : null,
                maxScale: _selectedType == 'Linear Scale' ? _maxScale : null,
                minScaleLabel: _selectedType == 'Linear Scale' ? _minScaleLabelController.text : null,
                maxScaleLabel: _selectedType == 'Linear Scale' ? _maxScaleLabelController.text : null,
                selectionType: _selectionType,
                selectionNumber: int.tryParse(_selectionNumberController.text),
                customErrorMessage: _selectionType != _selectionTypeOptions[0]
                    ? _customErrorMessageController.text
                    : null,
                required: _isRequired,
              );

              widget.onAdd(question);
              Navigator.pop(context);
            } else {
              Get.snackbar(
                "Error",
                "Please provide a question.",
                icon: const Icon(Icons.error),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: kPrimary, // Background color
            foregroundColor: Colors.white, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            elevation: 2, // Shadow elevation
          ),
          child: Text(
            widget.question == null ? 'Add' : 'Update',
            style: const TextStyle(
              fontSize: 16, // Text size
              fontWeight: FontWeight.bold, // Text weight
            ),
          ),
        ),
      ],
    );
  }
}