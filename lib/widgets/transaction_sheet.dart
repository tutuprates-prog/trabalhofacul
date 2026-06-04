// lib/widgets/transaction_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';

class TransactionSheet extends ConsumerStatefulWidget {
  final TransactionModel? existing;
  const TransactionSheet({super.key, this.existing});

  @override
  ConsumerState<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends ConsumerState<TransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  late TransactionType _type;
  late String _category;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final tx = widget.existing;
    _type = tx?.type ?? TransactionType.expense;
    _date = tx?.date ?? DateTime.now();
    _category = tx?.category ??
        (_type == TransactionType.income
            ? TransactionModel.incomeCategories.first
            : TransactionModel.expenseCategories.first);
    if (tx != null) {
      _titleCtrl.text = tx.title;
      _amountCtrl.text = tx.amount.toStringAsFixed(2);
      _descCtrl.text = tx.description ?? '';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  List<String> get _categories => _type == TransactionType.income
      ? TransactionModel.incomeCategories
      : TransactionModel.expenseCategories;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final userId = ref.read(authProvider).user!.id!;
    final amount =
        double.parse(_amountCtrl.text.replaceAll(',', '.'));

    final tx = TransactionModel(
      id: widget.existing?.id,
      userId: userId,
      title: _titleCtrl.text.trim(),
      amount: amount,
      date: _date,
      type: _type,
      category: _category,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
    );

    final notifier = ref.read(transactionProvider.notifier);
    if (widget.existing != null) {
      await notifier.update(tx);
    } else {
      await notifier.add(tx);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isIncome = _type == TransactionType.income;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                Text(
                  widget.existing == null ? 'Nova transação' : 'Editar transação',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),

                // Tipo (entrada/saída)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _type = TransactionType.income;
                            _category =
                                TransactionModel.incomeCategories.first;
                          }),
                          child: AnimatedContainer(
                            duration: 200.milliseconds,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isIncome ? Colors.green : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_downward,
                                    size: 16,
                                    color: isIncome
                                        ? Colors.white
                                        : Colors.grey),
                                const SizedBox(width: 6),
                                Text('Receita',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isIncome
                                            ? Colors.white
                                            : Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _type = TransactionType.expense;
                            _category =
                                TransactionModel.expenseCategories.first;
                          }),
                          child: AnimatedContainer(
                            duration: 200.milliseconds,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color:
                                  !isIncome ? Colors.red : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_upward,
                                    size: 16,
                                    color: !isIncome
                                        ? Colors.white
                                        : Colors.grey),
                                const SizedBox(width: 6),
                                Text('Despesa',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: !isIncome
                                            ? Colors.white
                                            : Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Título
                TextFormField(
                  controller: _titleCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Título *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o título' : null,
                ),
                const SizedBox(height: 14),

                // Valor
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Valor *',
                    prefixText: 'R\$ ',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe o valor';
                    final n = double.tryParse(v.replaceAll(',', '.'));
                    if (n == null || n <= 0) return 'Valor numérico inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Data
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                    ),
                    child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                  ),
                ),
                const SizedBox(height: 14),

                // Categoria
                DropdownButtonFormField<String>(
                  value: _categories.contains(_category)
                      ? _category
                      : _categories.first,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const SizedBox(height: 14),

                // Descrição (opcional)
                TextFormField(
                  controller: _descCtrl,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descrição (opcional)',
                  ),
                ),
                const SizedBox(height: 28),

                // Salvar
                _saving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isIncome ? Colors.green : cs.primary,
                        ),
                        child: Text(widget.existing == null
                            ? 'Adicionar'
                            : 'Salvar alterações'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Duration {
  Duration get milliseconds => this;
}
