import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_firestore_unittest/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

@Timeout(Duration(seconds: 2))
void main() {
  late ProviderContainer container;
  const uid = 'werewolf';
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final mockUser = MockUser(isAnonymous: true, uid: uid);
    container = ProviderContainer(
      overrides: [
        firebaseAuthProvider.overrideWithProvider(
          Provider((ref) => MockFirebaseAuth(mockUser: mockUser)),
        ),
        firebaseFirestoreProvider.overrideWithProvider(
          Provider((ref) => FakeFirebaseFirestore()),
        ),
      ],
    );
  });
  test('ユーザが作成できるか', () async {
    await container.read(userRepositoryProvider).createUser();
    final user = await container.read(userRepositoryProvider).fetchUser(uid);
    expect(user!.authId, uid);
    expect(user.username, 'ワンナイト人狼だいすキッズ');
  });
}
