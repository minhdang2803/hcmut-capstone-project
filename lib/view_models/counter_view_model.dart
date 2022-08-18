import 'package:capstone_project_hcmut/view_models/abstract/base_provider_model.dart';
import 'package:capstone_project_hcmut/view_models/abstract/base_view_model.dart';

class CounterModel {
  int counter = 0;
}

class CounterViewModel extends BaseProvider {
  //Singleton Pattern
  final BaseProviderModel<CounterModel> _counterViewModel =
      BaseProviderModel.init(data: CounterModel());
  BaseProviderModel<CounterModel> get data => _counterViewModel;
  CounterModel get instance => _counterViewModel.data!;

  void increase() {
    instance.counter++;
    notifyListeners();
  }

  void decrease() {
    instance.counter--;
    notifyListeners();
  }
}
