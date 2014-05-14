package utils.common.util {
    import flash.net.LocalConnection;

    public class AppUtil {
        public static function gc():void {
            try {
                new LocalConnection().connect("k7k7k7k");
                new LocalConnection().connect("k7k7k7k");
            } catch(error:Error) {
            }
        }
    }
}