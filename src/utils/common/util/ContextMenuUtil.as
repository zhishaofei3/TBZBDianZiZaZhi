/**
 *
 */
package utils.common.util {
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.ui.ContextMenu;

    public class ContextMenuUtil {
        private static var dic:Array = []
        private static var _stage:Stage;

        public static function setMenu(p:InteractiveObject, ar:Array):void {
            if (p.stage != null) {
                dic.push({m:p, ar:ar});
                p.addEventListener(Event.REMOVED_FROM_STAGE, _re)
                if (!p.stage.getChildAt(0).hasEventListener(ContextMenuEvent.MENU_SELECT)) {
                    var menu:ContextMenu = new ContextMenu();
                    menu.addEventListener(ContextMenuEvent.MENU_SELECT, _s);
                    InteractiveObject(p.stage.getChildAt(0)).contextMenu = menu;
                }
            }
        }

        private static function _re(event:Event):void {
            for (var i:int = 0; i < dic.length; i++) {
                if (dic[i].m == event.target) {
                    dic.splice(i, 1);
                    return;
                }
            }
        }

        private static function _s(event:ContextMenuEvent):void {
            for (var n:int = 0; n < dic.length; n++) {
                var mm:Object = dic[n].m;
                if (mm != null && mm.stage != null) {
                    _stage = mm.stage;
                    break;
                }
            }
            if (_stage == null)return;
            var ar:InteractiveObject = getObj(_stage);
            if (ar != null) {
                for (var i:int = 0; i < dic.length; i++) {
                    var m:InteractiveObject = dic[i].m;
                    var menu:Array = dic[i].ar;
                    if (m == ar) {
                        if (m != null && m.stage != null && menu != null) {
                            event.contextMenuOwner.contextMenu.customItems = menu;
                            return;
                        }
                    }
                }
            } else {
                event.contextMenuOwner.contextMenu.customItems = [];
            }
        }

        private static function getObj(stage:Stage):InteractiveObject {
            var parr:Array = []
            for (var i:int = 0; i < dic.length; i++) {
                if (dic[i].m != null && dic[i].m.stage != null) {
                    if ((dic[i].m as InteractiveObject).hitTestPoint(stage.mouseX, stage.mouseY, true) && ((dic[i].m as InteractiveObject).visible)) {
                        parr.push(dic[i].m);
                    }
                }
            }
            if (parr.length == 0)return null;
            return getp(stage, parr);
        }

        private static function getp(stage:DisplayObjectContainer, parr:Array):InteractiveObject {
            if (parr.length == 1) {
                return parr[0];
            }
            for (var j:int = stage.numChildren - 1; j > -1; j--) {
                if (stage.getChildAt(j) is DisplayObjectContainer) {
                    var con:DisplayObjectContainer = DisplayObjectContainer(stage.getChildAt(j));
                    var find:Boolean;
                    for (var mm:int = 0; mm < parr.length; mm++) {
                        if (con == parr[mm]) {
                            return con;
                        }
                        if (con.contains(parr[mm])) {
                            find = true;
                            break;
                        }
                    }
                    if (find) {
                        for (var mn:int = 0; mn < parr.length; mn++) {
                            if (!con.contains(parr[mn])) {
                                parr.splice([mn], 1)
                                mn--;
                            }
                        }
                        return getp(con, parr);
                    }
                }
            }
            return null;
        }
    }
}