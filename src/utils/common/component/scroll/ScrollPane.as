package utils.common.component.scroll {

    import utils.common.component.event.BaseEvent;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;

    /**
     * @author WuWenjun
     */
    public class ScrollPane extends EventDispatcher {
        private var content:DisplayObjectContainer;
        private var maskRec:Rectangle;
        private var sc:ScrollBar;
        private var up:InteractiveObject;
        private var down:InteractiveObject;
        private var drag:InteractiveObject;
        private var scbg:DisplayObject;

        public function ScrollPane(sp:DisplayObjectContainer, upbtn:InteractiveObject, downbtn:InteractiveObject, dragbtn:InteractiveObject, scbg:DisplayObject, maskrec:Rectangle=null) {
            this.content = sp;
            this.maskRec = maskrec;
            if(this.maskRec==null) {
                this.maskRec = new Rectangle(0, 0, content.width, content.height);
            }
            this.up = upbtn;
            this.down = downbtn;
            this.drag = dragbtn;
            this.scbg = scbg;
            sc = new ScrollBar(upbtn, downbtn, dragbtn, scbg);
            //
            content.scrollRect = this.maskRec.clone();
            sc.addEventListener(ScrollBar.SCROLL, onScroll);
            sp.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            update();
        }

        private function onRemove(event:Event):void {
            sc.removeEventListener(ScrollBar.SCROLL, onScroll);
        }

        private function onScroll(event:BaseEvent):void {
            var s:int = int(event.data);
            scrollTo(s);
        }

        private function getH():int {
            var bottom:Number = 0;
            var top:Number = 0;
            for (var i:int = 0; i < content.numChildren; i++) {
                var mmm:DisplayObject = content.getChildAt(i);
                if (mmm.y < top) {
                    top = mmm.y;
                }
                if (mmm.y + mmm.height > bottom) {
                    bottom = mmm.y + mmm.height;
                }
            }
            return bottom - top;
        }

        public function update():void {
            if (getH() < maskRec.height) {
                setScrollVisible(false);
            } else {
                setScrollVisible(true);
            }
        }

        private function setScrollVisible(b:Boolean):void {
            if (up != null) {
                up.visible = b;
            }
            if (down != null) {
                down.visible = b;
            }
            if (drag != null) {
                drag.visible = b;
            }
            if (scbg != null) {
                scbg.visible = b;
            }
        }

        /**
         * 滚动到位置
         * @param n 0-100
         */
        public function scrollTo(n:int):void {
            content.scrollRect = new Rectangle(maskRec.x, (getH() - maskRec.height + 1) * n / 100, maskRec.width, maskRec.height)
        }
    }
}
