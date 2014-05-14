/**
 * Created by IntelliJ IDEA.
 * User: wuwenjun
 * Date: 11-12-23
 * Time: 上午9:50
 */
package utils.common.util {
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class McUtil {
        private static var backDic:Dictionary = new Dictionary();
        private static var startDic:Dictionary = new Dictionary();
        private static var endDic:Dictionary = new Dictionary();
        private static var sp:Sprite = init();
        private static var playremoves:Array = [];
        private static var sp1:Sprite;

        private static function init():Sprite {
            sp1 = new Sprite();
            sp1.addEventListener(Event.ENTER_FRAME, _playRemoveCheck);
            return sp1;
        }

        private static function _playRemoveCheck(event:Event):void {
            for (var i:int = 0; i < playremoves.length; i++) {
                var mc:MovieClip = playremoves[i];
                if (mc.currentFrame == mc.totalFrames) {
                    if (mc.parent != null) {
                        mc.parent.removeChild(mc);
                        return;
                    }
                    playremoves.splice(i, 1);
                    if (playremoves.length == 0) {
                        sp1.removeEventListener(Event.ENTER_FRAME, _playRemoveCheck);
                    }
                }
                mc.nextFrame();
            }
        }

        public static function playRemove(mc:MovieClip):void {
            if (mc == null)return;
            playremoves.push(mc);
            if (sp1.hasEventListener(Event.ENTER_FRAME)) {
                return;
            }
            sp1.addEventListener(Event.ENTER_FRAME, _playRemoveCheck);
        }

        /**
         * 播放一次
         * @param start 开始帧或标签
         * @param end    结束帧或标签
         * @param back    播放结束后去到的目的帧或标签
         */
        public static function playOnce(mc:MovieClip, start:Object, end:Object, back:Object):void {
            if (mc == null)return;
            mc.gotoAndStop(start);
            backDic[mc] = back;
            startDic[mc] = start;
            endDic[mc] = end;
            mc.addEventListener(Event.ENTER_FRAME, _ent1);
        }

        private static function _ent1(event:Event):void {
            var mc:MovieClip = MovieClip(event.target);
            if (endDic[mc] is String) {
                if (mc.currentLabel == endDic[mc]) {
                    mc.gotoAndStop(backDic[mc]);
                } else {
                    mc.nextframe();
                }
            } else if (endDic[mc] is Number) {
                if (mc.currentFrame == endDic[mc]) {
                    mc.gotoAndStop(backDic[mc]);
                } else {
                    mc.nextframe();
                }
            }
        }

        /**
         * 在Start和end间循环播放
         */
        public static function loop(mc:MovieClip, start:Object, end:Object):void {
            if (mc == null)return;
            mc.gotoAndStop(start);
            startDic[mc] = start;
            endDic[mc] = end;
            mc.addEventListener(Event.ENTER_FRAME, _ent2);
        }

        private static function _ent2(event:Event):void {
            var mc:MovieClip = MovieClip(event.target);
            if (endDic[mc] is String) {
                if (mc.currentLabel == endDic[mc]) {
                    mc.gotoAndStop(startDic[mc]);
                } else {
                    mc.nextframe();
                }
            } else if (endDic[mc] is Number) {
                if (mc.currentFrame == endDic[mc]) {
                    mc.gotoAndStop(startDic[mc]);
                } else {
                    mc.nextframe();
                }
            }
        }

        public static function stop(mc:MovieClip):void {
            mc.removeEventListener(Event.ENTER_FRAME, _ent1);
            mc.removeEventListener(Event.ENTER_FRAME, _ent2);
            delete startDic[mc];
            delete backDic[mc];
            delete endDic[mc];
        }
    }
}
