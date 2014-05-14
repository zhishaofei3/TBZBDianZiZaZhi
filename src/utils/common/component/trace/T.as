package utils.common.component.trace {
    import utils.common.component.extfl.CustomSimpleButton;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;

    /**
     * @author WWJ
     */
    public class T extends EventDispatcher {
        private static var dmc:Sprite;
        private static var b:CustomSimpleButton;
        private static var b1:CustomSimpleButton;
        private static var txt:TextField;
        //
        private static var isStop:Boolean = false;
        private static var ww:int;
        private static var hh:int;
        private static var logLevel:int;
        /////////
        public static function error(...arg):void {
            if (isStop)return;
            if (dmc == null)return;
            var str:String = arg.join(",");
            txt.htmlText += ("<font color='#ff0000'>" + str + "</font><br>");
        }

        public static function t(...arg):void {
            if (isStop)return;
            if (dmc == null)return;
            if (logLevel == 1)return;
            var str:String = arg.join(",");
            txt.htmlText += ("<font>" + str + "</font><br>");
        }

        /**
         *
         * @param dis
         * @param logLevel 0:输出所有.1:输出Error
         */
        public static function init(dis:DisplayObjectContainer, initStatus:int, logLevel:int, w:int = 800, h:int = 600):void {
            if (initStatus == 0)return;
            if (dmc != null)return;
            T.logLevel = logLevel;
            ww = w;
            hh = h;
            dmc = new Sprite();
            dmc.graphics.lineStyle(0);
            dmc.graphics.beginFill(0xeeeeee);
            dmc.graphics.drawRect(0, 0, w - 40, 25);
            dmc.graphics.endFill();
            dmc.x = 20;
            dmc.y = 20;
            dis.parent.addChild(dmc);
            //
            txt = new TextField();
            dmc.addChild(txt);
            txt.width = dmc.width;
            txt.height = h - 40 - 24;
            txt.y = 24;
            txt.multiline = true;
            txt.type = TextFieldType.INPUT;
            txt.border = true;
            txt.background = true;
            txt.backgroundColor = 0xffffff;
            //
            ////////
            b = new CustomSimpleButton("清除");
            b.x = 10;
            b.y = 5;
            b.addEventListener(MouseEvent.CLICK, clear, false, 0, true);
            dmc.addChild(b);
            b1 = new CustomSimpleButton("停止");
            b1.x = 50;
            b1.y = 5;
            b1.addEventListener(MouseEvent.CLICK, stopTrace, false, 0, true);
            dmc.addChild(b1);
            var b2:CustomSimpleButton = new CustomSimpleButton("[X]");
            b2.x = w - 40 - 30;
            b2.y = 5;
            b2.addEventListener(MouseEvent.CLICK, closeTrace, false, 0, true);
            dmc.addChild(b2);
            //
            dmc.visible = false;
            //
            dis.stage.addEventListener(KeyboardEvent.KEY_DOWN, toggleOpen, false, 0, true);
            //
            if (initStatus == 1) {
                stopTrace();
            }
        }

        private static function closeTrace(event:MouseEvent):void {
            dmc.visible = false;
        }

        private static function toggleOpen(event:KeyboardEvent):void {
            if (event.ctrlKey && event.altKey && event.shiftKey && event.keyCode == 192) {
                dmc.visible = !dmc.visible;
            }
        }

        private static function stopTrace(event:MouseEvent = null):void {
            isStop = !isStop;
            if (isStop) {
                b1.label = "开启";
            } else {
                b1.label = "关闭";
            }
        }

        private static function clear(event:MouseEvent):void {
            txt.text = "";
        }
    }
}
