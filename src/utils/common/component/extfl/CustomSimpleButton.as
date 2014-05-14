package utils.common.component.extfl {
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;

    /**
     * @author WWJ
     */
    public class CustomSimpleButton extends SimpleButton {
        private var _data:Object;
        private var _label:String;
        private var t:TextField;

        public function CustomSimpleButton(txt:String) {
            t = new TextField();
            t.autoSize = TextFieldAutoSize.LEFT;
            this.label = txt;
            useHandCursor = true;
        }

        private function drawState():void {
            var w:int = t.width;
            var h:int = t.height;
            downState = new CustomButtonDisplayState(label, 0x00CCFF, w, h);
            overState = new CustomButtonDisplayState(label, 0xCCFF00, w, h);
            upState = new CustomButtonDisplayState(label, 0xFFCC00, w, h);
            hitTestState = new CustomButtonDisplayState(label, 0xFFCC00, w, h);
        }

        public function get data():Object {
            return _data;
        }

        public function set data(data:Object):void {
            _data = data;
        }

        public function get label():String {
            return _label;
        }

        public function set label(label:String):void {
            _label = label;
            t.text = label;
            drawState();
        }
    }
}

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

class CustomButtonDisplayState extends Sprite {
    private var bgColor:uint;
    private var h:uint;
    private var w:uint;
    private var str:String;

    public function CustomButtonDisplayState(str:String, bgColor:uint, w:uint, h:uint) {
        this.str = str;
        this.w = w;
        this.h = h;
        this.bgColor = bgColor;
        draw();
    }

    private function draw():void {
        if (str == "") {
            w = 20;
            h = 20;
        }
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, w, h);
        graphics.endFill();
        if (str == "") {
            var tt:Sprite = new Sprite();
            tt.graphics.beginFill(0);
            tt.graphics.drawRect(0, 0, 10, 10);
            tt.graphics.endFill();
            tt.x = (w - 10) / 2;
            tt.y = (h - 10) / 2;
            addChild(tt);
        } else {
            var t:TextField = new TextField();
            t.autoSize = TextFieldAutoSize.LEFT;
            t.text = str;
            t.selectable = false;
            this.addChild(t);
        }
    }
}
