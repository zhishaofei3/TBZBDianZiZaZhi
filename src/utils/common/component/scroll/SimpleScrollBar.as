/**
 *
 */
package utils.common.component.scroll {

    import utils.common.component.event.BaseEvent;
    import utils.common.component.extfl.CustomSimpleButton;

    import flash.display.Sprite;
    import flash.events.Event;

    public class SimpleScrollBar extends Sprite {
        public static const HORIZONTAL:int = 0;
        public static const VERTICAL:int = 1;
        private var up:CustomSimpleButton;
        private var drog:CustomSimpleButton;
        private var down:CustomSimpleButton;
        private var scroller:ScrollBar;

        public function SimpleScrollBar(len:int, dir:int = VERTICAL) {
            var sp:Sprite = new Sprite();
            addChild(sp);
            up = new CustomSimpleButton("");
            drog = new CustomSimpleButton("");
            down = new CustomSimpleButton("");
            sp.addChild(up);
            sp.addChild(drog);
            sp.addChild(down);
            up.y = 0;
            drog.y = up.y + up.height;
            down.y = len - down.height;
            scroller = new ScrollBar(up, down, drog, null)
            scroller.addEventListener("SCROLL", onScroll);
            if (dir == HORIZONTAL) {
                sp.rotation = -90;
            }
            addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
        }

        private function onRemove(event:Event):void {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            scroller.removeEventListener("SCROLL", onScroll);
            scroller = null;
        }

        private function onScroll(event:BaseEvent):void {
            var be:BaseEvent = new BaseEvent(event.type);
            be.data = event.data;
            dispatchEvent(be);
        }
    }
}
