// import 'package:flutter_test/flutter_test.dart';
// import 'package:lifts_app/repository/lifts_repository.dart';
// import 'package:lifts_app/view_models/ride_view_model.dart';
// import 'package:mockito/mockito.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MockLiftsRepository extends Mock implements LiftsRepository {}
// class MockFirebaseAuth extends Mock implements FirebaseAuth {}
// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
//
// void main() {
//   group('LiftsViewModel', () {
//     late LiftsViewModel liftsViewModel;
//     late MockLiftsRepository mockLiftsRepository;
//     late MockFirebaseAuth mockFirebaseAuth;
//     late MockFirebaseFirestore mockFirebaseFirestore;
//
//     setUp(() {
//       mockLiftsRepository = MockLiftsRepository();
//       mockFirebaseAuth = MockFirebaseAuth();
//       mockFirebaseFirestore = MockFirebaseFirestore();
//       liftsViewModel = LiftsViewModel(
//       );
//     });
//
//     test('initial values are correct', () {
//       expect(liftsViewModel.lifts, []);
//       expect(liftsViewModel.isLoading, false);
//     });
//
//     test('fetchLifts sets isLoading to true and then false', () async {
//       when(mockLiftsRepository.getLifts()).thenAnswer((_) async => []);
//       await liftsViewModel.fetchLifts();
//       expect(liftsViewModel.isLoading, false);
//     });
//
//     test('getJoinedLifts returns correct stream', () {
//       final userId = 'testUserId';
//       final stream = Stream<QuerySnapshot>.empty();
//       when(mockLiftsRepository.getJoinedLifts(userId)).thenAnswer((_) => stream);
//       expect(liftsViewModel.getJoinedLifts(userId), stream);
//     });
//   });
// }
