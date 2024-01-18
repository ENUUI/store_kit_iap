// Generate a v4
import 'package:uuid/uuid.dart';

String uuid() {
  const u = Uuid();
  return u.v4();
}
