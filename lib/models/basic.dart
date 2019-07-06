
abstract class Basic{
  final String id;

  Basic(this.id);

  bool operator==(o)=> o is Basic&&o.id==id;
  @override
  int get hashCode => id.hashCode;
}