/**
 * Created by MAOXIANWANG.
 * User: WWJ
 * Date: 11-1-3
 * Time: 下午8:25
 */
package utils.common.component.scroll {
    import utils.common.component.event.BaseEvent;

    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    /**
     * 滚动时广播的数字为0-100
     */
    public class ScrollBar extends EventDispatcher {
        private var bg:DisplayObject;
        private var up:InteractiveObject;
        private var down:InteractiveObject;
        private var drag:InteractiveObject;
        //////////////////////
        //多少帧滚动一次
        private var _scrollSpeed:int = 2;
        //当上下按钮按下时滚动的百分比
        private const rate:int = 5;
        private const _delay:int = 300;
        private var _percent:int = 0;
        private var s:int = 0;
        //按下上按钮后暂停时间再连续滚动,毫秒
        private var timeout:uint;
        private var dragArea:Rectangle;
        public static const SCROLL:String = "SCROLL";
        private var lastR:int = -1;

        public function ScrollBar(upbtn:InteractiveObject, downbtn:InteractiveObject, dragbtn:InteractiveObject, scbg:DisplayObject = null) {
            this.bg = scbg;
            this.up = upbtn;
            this.down = downbtn;
            this.drag = dragbtn;
            ///
            var uprec:Rectangle = upbtn.getBounds(upbtn.parent);
            var downrec:Rectangle = downbtn.getBounds(downbtn.parent);
            var dragrec:Rectangle = dragbtn.getBounds(dragbtn.parent);
            dragArea = new Rectangle(dragbtn.x, dragbtn.y - (dragrec.y - uprec.y - uprec.height), 0, downrec.y - uprec.y - uprec.height - dragrec.height);
            percent = 0;
            initEvent();
        }

        private function initEvent():void {
            up.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
            up.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage, false, 0, true);
            //
            this.up.addEventListener(MouseEvent.MOUSE_DOWN, _up, false, 0, true);
            this.down.addEventListener(MouseEvent.MOUSE_DOWN, _down, false, 0, true);
            this.drag.addEventListener(MouseEvent.MOUSE_DOWN, _drag, false, 0, true);
            if (drag.stage != null) {
                drag.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUp, false, 0, true);
            }
        }

        private function onRemoveFromStage(event:Event):void {
            clearTimeout(timeout);
            up.stage.removeEventListener(Event.ENTER_FRAME, moveUp);
            up.stage.removeEventListener(Event.ENTER_FRAME, moveDown);
            up.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __drag);
            up.stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUp);
            this.up.removeEventListener(MouseEvent.MOUSE_DOWN, _up);
            this.down.removeEventListener(MouseEvent.MOUSE_DOWN, _down);
            this.drag.removeEventListener(MouseEvent.MOUSE_DOWN, _drag);
        }

        private function onAddToStage(event:Event):void {
            up.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
            up.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUp, false, 0, true);
        }

        private function _drag(event:MouseEvent):void {
            up.stage.addEventListener(MouseEvent.MOUSE_MOVE, __drag, false, 0, true);
        }

        private function __drag(event:MouseEvent):void {
            if (dragArea.y < up.parent.mouseY && dragArea.y + dragArea.height > up.parent.mouseY) {
                percent = (up.parent.mouseY - dragArea.y) / dragArea.height * 100;
            } else {
                if (dragArea.y >= up.parent.mouseY) {
                    percent = 0;
                }
                if (dragArea.y + dragArea.height <= up.parent.mouseY) {
                    percent = 100;
                }
            }
            update();
            dispatch();
        }

        private function _down(event:MouseEvent):void {
            percent += rate;
            if (percent > 100) {
                percent = 100;
                return;
            }
            update();
            dispatch();
            /////////
            timeout = setTimeout(__down, _delay)
        }

        private function __down():void {
            up.stage.addEventListener(Event.ENTER_FRAME, moveDown, false, 0, true);
        }

        private function moveUp(event:Event):void {
            s--;
            if (s > 0) {
                return;
            }
            s = scrollSpeed;
            percent -= rate;
            if (percent < 0) {
                percent = 0;
            }
            update();
            dispatch();
        }

        private function moveDown(event:Event):void {
            s--;
            if (s > 0) {
                return;
            }
            s = scrollSpeed;
            percent += rate;
            if (percent > 100) {
                percent = 100;
            }
            update();
            dispatch()
        }

        private function _up(event:MouseEvent):void {
            percent -= rate;
            if (percent < 0) {
                percent = 0;
                return;
            }
            update();
            dispatch();
            /////////
            timeout = setTimeout(__up, _delay)
        }

        private function __up():void {
            up.stage.addEventListener(Event.ENTER_FRAME, moveUp, false, 0, true);
        }

        private function _mouseUp(event:MouseEvent):void {
            s = scrollSpeed;
            clearTimeout(timeout);
            up.stage.removeEventListener(Event.ENTER_FRAME, moveUp);
            up.stage.removeEventListener(Event.ENTER_FRAME, moveDown);
            up.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __drag);
        }

        private function dispatch():void {
            if (lastR == percent)return;
            var e:BaseEvent = new BaseEvent(SCROLL);
            e.data = percent;
            dispatchEvent(e);
            lastR = percent;
        }

        public function update():void {
            drag.y = dragArea.y + percent * dragArea.height / 100;
        }

        public function get scrollSpeed():int {
            return _scrollSpeed;
        }

        public function set scrollSpeed(value:int):void {
            _scrollSpeed = value;
        }

        public function get percent():int {
            return _percent;
        }

        /**
         * 设置滚动条的位置
         * @param value 0-100
         */
        public function set percent(value:int):void {
            _percent = value;
            update();
            dispatch();
        }
    }
}
