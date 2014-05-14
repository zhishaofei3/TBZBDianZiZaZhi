/**
 * Created by IntelliJ IDEA.
 * User: wuwenjun
 * Date: 12-2-3
 * Time: 下午5:03
 */
package utils.common.util {
    import flash.display.Sprite;
    import flash.events.Event;

    public class FrameEventUtility {
        private static var mc:Sprite;
        private static var runs:Vector.<Function> = new Vector.<Function>();

        private static function init():void {
            mc = new Sprite();
            mc.addEventListener(Event.ENTER_FRAME, enterFrame);
        }

        init();
        private static function enterFrame(event:Event):void {
            for (var i:int = 0; i < runs.length; i++) {
                runs[i]();
            }
        }

        public static function add(run:Function):void {
            if (runs.indexOf(run) != -1) {
                return;
            }
            runs.push(run);
        }

        public static function remove(run:Function):void {
            for (var i:int = 0; i < runs.length; i++) {
                if (runs[i] == run) {
                    runs.splice(i, 1);
                    return;
                }
            }
        }
    }
}
