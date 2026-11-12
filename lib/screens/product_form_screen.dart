import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.product, super.key});

  final Product? product;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageUrlController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    _categoryController = TextEditingController(
      text: product?.categoryId.toString() ?? '',
    );
    _imageUrlController = TextEditingController(text: product?.imageUrl ?? '');
  }

  @override
  void dispose() {
    for (final controller in [
      _nameController,
      _descriptionController,
      _priceController,
      _stockController,
      _categoryController,
      _imageUrlController,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    final errorMessage = ref.watch(productProvider).errorMessage;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit product' : 'Add product')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (errorMessage != null) ...[
              Text(
                errorMessage,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 16),
            ],
            _textField(_nameController, 'Name'),
            _textField(_descriptionController, 'Description', maxLines: 3),
            _textField(
              _priceController,
              'Price',
              keyboardType: TextInputType.number,
            ),
            _textField(
              _stockController,
              'Stock',
              keyboardType: TextInputType.number,
            ),
            _textField(
              _categoryController,
              'Category ID',
              keyboardType: TextInputType.number,
            ),
            _textField(
              _imageUrlController,
              'Image URL (optional)',
              required: false,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save changes' : 'Add product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    bool required = true,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) => value == null || value.trim().isEmpty
                  ? '$label is required'
                  : null
            : null,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceController.text.trim());
    final stock = int.tryParse(_stockController.text.trim());
    final categoryId = int.tryParse(_categoryController.text.trim());
    if (price == null ||
        price < 0 ||
        stock == null ||
        stock < 0 ||
        categoryId == null ||
        categoryId < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid non-negative numeric values.'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final notifier = ref.read(productProvider.notifier);
    final success = widget.product == null
        ? await notifier.createProduct(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            stock: stock,
            categoryId: categoryId,
            imageUrl: _imageUrlController.text.trim(),
          )
        : await notifier.updateProduct(
            id: widget.product!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            price: price,
            stock: stock,
            categoryId: categoryId,
            imageUrl: _imageUrlController.text.trim(),
          );
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (success) Navigator.of(context).pop();
  }
}
