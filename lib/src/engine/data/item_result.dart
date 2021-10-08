class ItemResult {
  String? variable;
  String? value;
  String? target;

  ItemResult.input(this.variable, this.value);

  ItemResult.choice(this.variable, this.value, this.target);
}
