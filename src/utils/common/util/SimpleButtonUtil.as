/**
 *
 */
package utils.common.util {
    import flash.display.DisplayObject;
    import flash.display.SimpleButton;

    public class SimpleButtonUtil {
        public static function toggle(b:SimpleButton):void {
            var e:DisplayObject = b.upState;
            b.upState = b.downState;
            b.downState = e;
        }
    }
}
