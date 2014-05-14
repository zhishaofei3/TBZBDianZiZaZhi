package utils.common.util {
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;

    public class MouseUtil {
        private static var stage:Stage;
        private static var mouse_mc:MovieClip;

        public static function initMouseUtility(c:Stage):void {
            stage = c;
        }

        private static function _onEnterFrame(e:Event):void {
            if (mouse_mc != null) {
                mouse_mc.x = stage.mouseX;
                mouse_mc.y = stage.mouseY;
                Mouse.hide();
            }
        }

        //鼠标按下时的处理
        private static function onMouseDown(e:MouseEvent):void {
            if (mouse_mc != null) {
                mouse_mc.gotoAndStop(2);
            }
        }

        //鼠标按下之后弹起处理
        private static function onMouseUp(e:MouseEvent):void {
            if (mouse_mc != null) {
                mouse_mc.gotoAndStop(1);
            }
        }

        //设置鼠标指针
        public static function setMouseCursor(c:Class):void {
            if (stage == null)return;
            if (c != null) {
                if (mouse_mc != null && (mouse_mc is c)) {
                    return;
                }
                removeCurrent();
                Mouse.hide();
                //
                mouse_mc = new c();
                stage.addChild(mouse_mc);
                mouse_mc.gotoAndStop(1);
                mouse_mc.mouseEnabled = false;
                mouse_mc.mouseChildren = false;
                //
                mouse_mc.x = stage.mouseX;
                mouse_mc.y = stage.mouseY;
                //
                stage.addEventListener(Event.ENTER_FRAME, _onEnterFrame, false, 0, true);
                if (mouse_mc.totalFrames == 2) {
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
                    stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
                }
            } else {
                removeCurrent();
                Mouse.show();
            }
        }

        private static function removeCurrent():void {
            if (stage == null)return;
            if (mouse_mc != null) {
                mouse_mc.parent.removeChild(mouse_mc);
                mouse_mc = null;
            }
            stage.removeEventListener(Event.ENTER_FRAME, _onEnterFrame);
            stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        }

        public static function restore():void {
            setMouseCursor(null);
        }
    }
}
