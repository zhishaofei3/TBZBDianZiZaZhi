/**
 *
 */
package utils.common.util {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class DragUtil {
        private static var map:Dictionary = new Dictionary(false);
        private static var curDrag:Sprite;
        //
        public static var maxWidth:int;
        public static var maxHeight:int;

        /**
         * 拖动一个对象,让另一个对象移动
         * @param t     点击对象
         * @param o     真正移动对象
         */
        public static function drag(t:Sprite, o:Sprite):void {
            map[t] = o;
            t.buttonMode = true;
            t.useHandCursor = true;
            //
            t.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
            t.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage, false, 0, true);
            if (t.stage != null) {
                initDrag(t);
            }
        }

        public static function remove(t:Sprite):void {
            removeDraging(t);
            t.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            t.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedToStage);
            delete map[t];
        }

        private static function onRemovedToStage(event:Event):void {
            removeDraging(Sprite(event.currentTarget))
        }

        private static function onAddedToStage(event:Event):void {
            initDrag(Sprite(event.currentTarget))
        }

        private static function removeDraging(t:Sprite):void {
            t.removeEventListener(MouseEvent.MOUSE_DOWN, dragT);
            if (t.stage != null) {
                t.stage.removeEventListener(MouseEvent.MOUSE_UP, dragSt);
                t.stage.removeEventListener(Event.MOUSE_LEAVE, dragSt);
            }
            var o:Sprite = map[t];
            if (o == null || o.stage == null) {
                return;
            }
            o.stopDrag();
        }

        private static function initDrag(t:Sprite):void {
            t.addEventListener(MouseEvent.MOUSE_DOWN, dragT, false, 0, true);
        }

        private static function dragT(event:Event):void {
            if (curDrag != null) {
                var o2:Sprite = map[curDrag];
                if (o2 != null && o2.stage != null) {
                    o2.stopDrag();
                }
            }
            curDrag = Sprite(event.currentTarget);
            var o:Sprite = map[event.currentTarget];
            if (o.stage == null) {
                return;
            }
            var rec:Rectangle = o.getBounds(o.stage);
            rec.x = o.x - rec.x;
            rec.y = o.y - rec.y;
            rec.width = maxWidth == 0 ? o.stage.stageWidth - o.width : maxWidth - o.width;
            rec.height = maxHeight == 0 ? o.stage.stageHeight - o.height : maxHeight - o.height;
            o.startDrag(false, rec);
            curDrag.stage.addEventListener(MouseEvent.MOUSE_UP, dragSt, false, 0, true);
            curDrag.stage.addEventListener(Event.MOUSE_LEAVE, dragSt, false, 0, true);
        }

        private static function dragSt(event:Event):void {
            if (curDrag == null) {
                return;
            }
            var o:Sprite = map[curDrag];
            if (o == null || o.stage == null) {
                return;
            }
            o.stopDrag();
        }
    }
}
