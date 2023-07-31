import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

class MockWidgetRef extends Mock implements WidgetRef {
  MockWidgetRef(this.container);
  ProviderContainer container;

  @override
  T read<T>(ProviderListenable<T> provider) {
    return container.read(provider);
  }
}