/**
 * Created by MAOXIANWANG.
 * User: WWJ
 * Date: 11-9-29
 * Time: 上午10:41
 */
package utils.common.util {
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class TipUtil {
        private static var map:Dictionary = new Dictionary(true);
        public static var maxWidth:int;
        public static var maxHeight:int;

        /**
         * 给显示对象创建浮框
         * 当显示对象移出舞台时,会取消注册
         * @param    mc        触发浮框的显示对象.可以不放到舞台上
         * @param    tip        浮框,可以不放到舞台上
         */
        public static function register(mc:InteractiveObject, tip:DisplayObject):void {
            if (mc == null || tip == null)return;
            unregister(mc);
            mc.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage, false, 0, true)
            //
            map[mc] = new TipInfo(mc, tip);
            if (mc.stage == null) {
                mc.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
            } else {
                initMc(mc);
            }
        }

        private static function onAddToStage(event:Event):void {
            event.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
            initMc(InteractiveObject(event.currentTarget));
        }

        private static function onRemoveFromStage(event:Event):void {
            event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage)
            unregister(InteractiveObject(event.currentTarget));
        }

        /**
         * 删除浮动提示
         * @param c
         */
        public static function unregister(c:InteractiveObject):void {
            var tip:TipInfo = map[c];
            if (tip == null)return;
            if (tip.tipmc.stage != null) {
                tip.tipmc.parent.removeChild(tip.tipmc);
            }
            delete map[c];
            c.removeEventListener(Event.ENTER_FRAME, _enter_frame);
            c.removeEventListener(MouseEvent.ROLL_OUT, _rollOut);
            c.removeEventListener(MouseEvent.ROLL_OVER, _rollOver);
        }

        /**
         * 隐藏浮动提示直至鼠标重新移到c上
         */
        public static function hide():void {
            for (var c:* in map) {
                if (map[c] != null) {
                    var tip:TipInfo = map[c];
                    if (tip.tipmc != null && tip.tipmc.stage != null) {
                        tip.tipmc.parent.removeChild(tip.tipmc);
                        c.removeEventListener(Event.ENTER_FRAME, _enter_frame);
                    }
                }
            }
        }

        private static function initMc(cc:InteractiveObject):void {
            var tip:TipInfo = map[cc];
            if (tip.tipmc.stage != null) {
                tip.tipmc.parent.removeChild(tip.tipmc);
            }
            cc.addEventListener(MouseEvent.ROLL_OVER, _rollOver, false, 0, true);
            cc.addEventListener(MouseEvent.ROLL_OUT, _rollOut, false, 0, true);
            var rec:Rectangle = cc.getBounds(cc.parent);
            if (rec.contains(cc.parent.mouseX, cc.parent.mouseY)) {
                __rollOver(cc);
            }
        }

        private static function _rollOver(event:MouseEvent):void {
            var mc:InteractiveObject = InteractiveObject(event.currentTarget);
            __rollOver(mc);
        }

        private static function __rollOver(mc:InteractiveObject):void {
            mc.addEventListener(Event.ENTER_FRAME, _enter_frame, false, 0, true);
            var tip:TipInfo = map[mc];
            if (tip.tipmc.stage == null) {
                mc.stage.addChild(tip.tipmc);
                modifyPosition(new Point(mc.stage.mouseX, mc.stage.mouseY), tip.tipmc);
            }
        }

        private static function _rollOut(event:MouseEvent):void {
            var mc:InteractiveObject = InteractiveObject(event.currentTarget);
            var tip:TipInfo = map[mc];
            if (tip.tipmc.stage != null) {
                tip.tipmc.parent.removeChild(tip.tipmc);
            }
            mc.removeEventListener(Event.ENTER_FRAME, _enter_frame);
        }

        private static function _enter_frame(event:Event):void {
            var mc:InteractiveObject = InteractiveObject(event.currentTarget);
            if (mc.stage == null)return;
            var tip:TipInfo = map[mc];
            modifyPosition(new Point(mc.stage.mouseX, mc.stage.mouseY), tip.tipmc);
        }

        private static function modifyPosition(mousep:Point, tipmc:DisplayObject):void {
            if (mousep.x > (maxWidth == 0 ? tipmc.stage.stageWidth : maxWidth) / 2) {
                tipmc.x = mousep.x - tipmc.width - 20;
            } else {
                tipmc.x = mousep.x + 20;
            }
            if (mousep.y + tipmc.height + 20 > (maxHeight == 0 ? tipmc.stage.stageHeight : maxHeight)) {
                tipmc.y = (maxHeight == 0 ? tipmc.stage.stageHeight : maxHeight) - tipmc.height;
            } else {
                tipmc.y = mousep.y + 20;
            }
        }
    }
}

import flash.display.DisplayObject;
import flash.display.InteractiveObject;

class TipInfo {
    private var _srcMc:InteractiveObject;
    private var _tipmc:DisplayObject;

    public function TipInfo(srcMc:InteractiveObject, tipmc:DisplayObject) {
        _srcMc = srcMc;
        _tipmc = tipmc;
    }

    public function get tipmc():DisplayObject {
        return _tipmc;
    }

    public function set tipmc(value:DisplayObject):void {
        _tipmc = value;
    }

    public function get srcMc():InteractiveObject {
        return _srcMc;
    }

    public function set srcMc(value:InteractiveObject):void {
        _srcMc = value;
    }
}
