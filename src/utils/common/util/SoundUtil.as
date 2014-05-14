package utils.common.util {

    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;

    public class SoundUtil {
        private static var onces:Array = new Array();
        private static var loops:Array = new Array();

        /**
         * 播放声音
         * @param    s            声音文件路径
         */
        public static function once(s:Sound):void {
            if (s == null)return;
            var sc:SoundChannel = s.play(0, 1);
            if (sc == null)return;
            sc.addEventListener(Event.SOUND_COMPLETE, oncePlayComplete);
            onces.push(sc);
            if (onces.length < 10)return;
            for (var i:int = 0; i < onces.length - 1; i++) {
                var soundChannel:SoundChannel = onces[i];
                if (soundChannel.position == 0) {
                    soundChannel.removeEventListener(Event.SOUND_COMPLETE, oncePlayComplete);
                    onces.splice(i, 1);
                    i--;
                }
            }
        }

        private static function oncePlayComplete(event:Event):void {
            for (var i:int = 0; i < onces.length; i++) {
                var soundChannel:SoundChannel = onces[i];
                if (soundChannel == event.target) {
                    event.target.removeEventListener(Event.SOUND_COMPLETE, oncePlayComplete)
                    onces.splice(i, 1);
                    return;
                }
            }
        }

        public static function loop(s:Sound):void {
            if (s == null)return;
            loops.push(s.play(0, 10000));
        }

        public static function stopLoop():void {
            for (var i:int = 0; i < loops.length; i++) {
                var sc:SoundChannel = loops[i];
                sc.stop();
            }
        }

        public static function stopOnce():void {
            for (var i:int = 0; i < onces.length; i++) {
                var sc:SoundChannel = onces[i];
                sc.stop();
            }
        }
    }
}
