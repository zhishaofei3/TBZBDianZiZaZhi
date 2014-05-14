package utils.common.component.tab {
    import utils.common.util.SimpleButtonUtil;

    import flash.display.DisplayObject;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.events.MouseEvent;

    /**
     * @author WuWenjun
     */
    public class TSwitcher {
        private var funcs:Array;
        private var btns:Array;
        private var last:SimpleButton;

        private function _click(e:MouseEvent):void {
            if (last != null) {
                last.mouseEnabled = true;
                last.enabled = true;
                SimpleButtonUtil.toggle(last);
            }
            last = SimpleButton(e.currentTarget);
            last.mouseEnabled = false;
            last.enabled = false;
            last.parent.setChildIndex(last, last.parent.numChildren - 1);

            SimpleButtonUtil.toggle(last);
            funcs[btns.indexOf(last)]();
        }

        /**
         * 按钮组管理
         * @param    btns        按钮数组
         * @param    funcs        按钮触发事件
         * @param    defaultind    按钮数组中默认激活的按钮，默认值为0，-1为所有按钮都不激活
         */
        public function TSwitcher(btns:Array, funcs:Array, defaultind:int = 0) {
            this.btns = btns;
            this.funcs = funcs;
            for (var i:int = 0; i < btns.length; i++) {
                (btns[i] as SimpleButton).addEventListener(MouseEvent.MOUSE_DOWN, _click);
            }
            if (defaultind != -1) {
                (btns[defaultind] as SimpleButton).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            (btns[0] as SimpleButton).addEventListener(Event.REMOVED_FROM_STAGE, _remove);
        }

        private function _remove(event:Event):void {
            event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, _remove);
            for (var i:int = 0; i < btns.length; i++) {
                (btns[i] as SimpleButton).removeEventListener(MouseEvent.MOUSE_DOWN, _click);
            }
            funcs = null;
            btns = null;
            last = null;
        }

        public function changeBtn(index:int):void {
            if (index < btns.length && index > -1) {
                (btns[index] as SimpleButton).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
        }
    }
}
