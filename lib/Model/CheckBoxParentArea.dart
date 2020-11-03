class CheckBoxParentArea {
  bool _isCheckedParent = true;

  bool get isChecked => _isCheckedParent;

  setIsCheckParent(bool isCheck) {
    this._isCheckedParent = isCheck;
  }

  getIsCheckParent() {
    return _isCheckedParent;
  }
}
