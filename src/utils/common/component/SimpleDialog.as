/**
 * Created by IntelliJ IDEA.
 * User: wuwenjun
 * Date: 12-3-23
 * Time: 下午12:04
 */
package utils.common.component {
    import utils.common.component.extfl.CustomSimpleButton;
    import utils.common.util.DisObjUtil;
    import utils.common.util.MethodUtil;

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.ui.Keyboard;

    public class SimpleDialog extends Sprite {
        public static const OK:int = 1; //00001
        public static const CANCEL:int = 2; //00010
        public static const YES:int = 4; //00100
        public static const NO:int = 8; //01000
        //10000
        public static const CLOSE:int = 16;
        private var title:String;
        private var msg:String;
        private var finishHandler:Function;
        private var buttons:int;
        private const WIDTH:Number = 300;
        private var btnMc:Sprite;
        private var bg:Sprite;
        private var gra:Sprite;
        //
        public function SimpleDialog(title:String, msg:String, btns:int = 1, finishHandler:Function = null) {
            this.title = title;
            this.msg = msg;
            this.buttons = btns;
            this.finishHandler = finishHandler;
            bg = new Sprite();
            addChild(bg);
            bg.addEventListener(MouseEvent.CLICK, empty, false, 0, true);
            gra = new Sprite();
            addChild(gra);
            //title
            showTitle();
            //body
            showBody();
            //bottom
            gra.graphics.beginFill(0xeeeeee);
            gra.graphics.drawRect(0, this.height - 1, WIDTH, 30);
            gra.graphics.endFill();
            //
            this.btnMc = new Sprite();
            addChild(btnMc);
            showBtn();
            addEventListener(Event.ADDED_TO_STAGE, onAdded);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        }

        private function onRemoved(event:Event):void {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function showBody():void {
            gra.graphics.beginFill(0xcccccc);
            gra.graphics.drawRect(0, this.height - 1, WIDTH, 150);
            gra.graphics.endFill();
            //
            var t:TextField = new TextField();
            t.width = WIDTH - 80;
            t.autoSize = TextFieldAutoSize.LEFT;
            t.multiline = true;
            t.wordWrap = true;
            t.text = msg;
            t.y = (150 - t.height) / 2;
            t.x = (WIDTH - t.width) / 2;
            gra.addChild(t);
        }

        private function showTitle():void {
            gra.graphics.lineStyle(1);
            gra.graphics.beginFill(0xaaaaaa);
            gra.graphics.drawRect(0, 0, WIDTH, 20);
            gra.graphics.endFill();
            //
            var t:TextField = new TextField();
            t.autoSize = TextFieldAutoSize.LEFT;
            t.text = title;
            t.mouseEnabled = false;
            t.y = (20 - t.height) / 2;
            gra.addChild(t);
            var tf:TextFormat = new TextFormat();
            tf.bold = true;
            t.setTextFormat(tf);
        }

        public static function show(d:DisplayObjectContainer, title:String, msg:String, btns:int = 1, finishHandler:Function = null):void {
            var dialog:SimpleDialog = new SimpleDialog(title, msg, btns, finishHandler);
            d.addChild(dialog);
        }

        private function empty(event:MouseEvent):void {
        }

        private function onAdded(event:Event):void {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            DisObjUtil.toStageCenter(this);
            var rec:Rectangle = this.getBounds(stage);
            bg.graphics.beginFill(0, 0.1);
            bg.graphics.drawRect(-rec.x, -rec.y, stage.stageWidth, stage.stageHeight);
            bg.graphics.endFill();
        }

        private function onKeyDown(event:KeyboardEvent):void {
            if (event.keyCode == Keyboard.ESCAPE) {
                if (finishHandler != null) {
                    finishHandler(CLOSE);
                }
                this.parent.removeChild(this);
            }
        }

        private function showBtn():void {
            if ((buttons & OK) == OK) {
                addBtn("确 定", OK);
            }
            if ((buttons & YES) == YES) {
                addBtn(" 是 ", YES)
            }
            if ((buttons & NO) == NO) {
                addBtn(" 否 ", NO);
            }
            if ((buttons & CANCEL) == CANCEL) {
                addBtn("取 消", CANCEL);
            }
            if ((buttons & CLOSE) == CLOSE) {
                addBtn("关 闭", CLOSE);
            }
        }

        private function addBtn(s:String, result:int):void {
            var b:CustomSimpleButton = new CustomSimpleButton(s);
            addChild(b);
            layout(b);
            b.addEventListener(MouseEvent.CLICK, MethodUtil.simple(click, result));
        }

        private function layout(b:CustomSimpleButton):void {
            btnMc.addChild(b);
            var pw:int = WIDTH / btnMc.numChildren;
            for (var i:int = 0; i < btnMc.numChildren; i++) {
                var mm:DisplayObject = btnMc.getChildAt(i);
                mm.x = i * pw + (pw - mm.width) / 2;
            }
            btnMc.y = this.height - 25;
        }

        private function click(result:int):void {
            if (finishHandler != null) {
                finishHandler(result);
            }
            this.parent.removeChild(this);
        }
    }
}
