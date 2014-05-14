package utils.common.component.display {
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    public class DelayPanel extends AbstractDisplayObject {
        private var timer:Timer;
        private var easyout:Boolean;

        /**
         * @param time        打开后如果鼠标不移到上面来,等待时间,毫秒
         * @param easyout     是否缓动
         */
        public function DelayPanel(time:Number, easyout:Boolean = false) {
            super();
            this.easyout = easyout;
            this.addEventListener(Event.ADDED_TO_STAGE, initMe);
            this.addEventListener(Event.REMOVED_FROM_STAGE, overMe);
            //
            this.timer = new Timer(time, 1);
        }

        private function overMe(event:Event):void {
            this.timer.stop();
            removeEventListener(Event.ENTER_FRAME, addAlpha);
            removeEventListener(Event.ENTER_FRAME, subAlpha);
            removeEventListener(MouseEvent.MOUSE_OVER, stopTimer);
            removeEventListener(MouseEvent.MOUSE_OUT, startTimer);
        }

        private function initMe(event:Event):void {
            if (easyout) {
                this.alpha = 0;
                addEventListener(Event.ENTER_FRAME, addAlpha);
            } else {
                this.appeared();
            }
        }

        private function addAlpha(event:Event):void {
            alpha += 0.1;
            if (alpha >= 1) {
                removeEventListener(Event.ENTER_FRAME, addAlpha);
                appeared();
            }
        }

        protected function appeared():void {
            this.addEventListener(MouseEvent.MOUSE_OVER, stopTimer, false, 0, true);
            this.addEventListener(MouseEvent.MOUSE_OUT, startTimer, false, 0, true);
            this.timer.addEventListener(TimerEvent.TIMER, disappear, false, 0, true);
            var b:Boolean = this.hitTestPoint(this.parent.mouseX, this.parent.mouseY);
            if (b) {
            } else {
                this.startTimer(null);
            }
        }

        private function startTimer(event:MouseEvent):void {
            this.timer.start();
        }

        private function stopTimer(event:MouseEvent):void {
            this.timer.stop();
        }

        private function disappear(event:TimerEvent):void {
            if (easyout) {
                addEventListener(Event.ENTER_FRAME, subAlpha);
                this.removeEventListener(MouseEvent.MOUSE_OVER, stopTimer);
                this.removeEventListener(MouseEvent.MOUSE_OUT, startTimer);
            } else {
                disappeared();
            }
        }

        private function subAlpha(event:Event):void {
            alpha -= 0.1;
            if (alpha <= 0) {
                disappeared();
                removeEventListener(Event.ENTER_FRAME, subAlpha);
            }
        }

        protected function disappeared():void {
                this.destroy();
        }

        override public function destroy():void {
            removeEventListener(Event.ADDED_TO_STAGE, initMe);
            removeEventListener(Event.REMOVED_FROM_STAGE, overMe);
            removeEventListener(Event.ENTER_FRAME, addAlpha);
            removeEventListener(Event.ENTER_FRAME, subAlpha);
            removeEventListener(MouseEvent.MOUSE_OVER, stopTimer);
            removeEventListener(MouseEvent.MOUSE_OUT, startTimer);
            if (timer != null) {
                this.timer.removeEventListener(TimerEvent.TIMER, disappear);
                this.timer.stop();
                timer = null;
            }
            super.destroy();
        }
    }
}
