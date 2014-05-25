/**
 * Created with 工具栏管理器.
 * User: zhishaofei
 * Date: 2014-5-14
 * Time: 13:53
 */
package core {
	import com.greensock.TweenLite;

	import data.ConfigManager;
	import data.PageMode;
	import data.infos.OtherBookInfo;

	import events.UIEvent;

	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;

	import scenes.LayerManager;

	import utils.common.util.DisObjUtil;

	public class ToolBarManager extends EventDispatcher {
		private var toolBar:UI_ToolBar;

		public function ToolBarManager() {
			toolBar = new UI_ToolBar();
			toolBar.alpha = 0.8;
			toolBar.logo.x = 20;
			LayerManager.toolContainer.addChild(toolBar);
			toolBar.centerBtns.bookName_mc.openPanel_spr.visible = false;
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible = false;
			toolBar.logo.addEventListener(MouseEvent.CLICK, onClickLogoBtnHandler);
			toolBar.centerBtns.bookName_mc.bookName_btn.buttonMode = true;
			toolBar.centerBtns.bookName_mc.bookName_btn.mouseChildren = false;
			toolBar.centerBtns.bookName_mc.bookName_btn.addEventListener(MouseEvent.CLICK, onClickBookNameBtnHandler);
			toolBar.centerBtns.dati_btn.addEventListener(MouseEvent.CLICK, onClickDatiBtnHandler);
			toolBar.centerBtns.qiehuan_mc.qiehuan_btn.addEventListener(MouseEvent.CLICK, onClickQieHuanMCHandler);
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.single_btn.addEventListener(MouseEvent.CLICK, onClickSingleBtnHandler);
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.double_btn.addEventListener(MouseEvent.CLICK, onClickDoubleBtnHandler);
			toolBar.centerBtns.zoomIn_btn.addEventListener(MouseEvent.CLICK, onClickZoomInBtnHandler);
			toolBar.centerBtns.zoomOut_btn.addEventListener(MouseEvent.CLICK, onClickZoomOutBtnHandler);
			toolBar.centerBtns.huanyuan_btn.addEventListener(MouseEvent.CLICK, onClickHuanYuanBtnHandler);
			toolBar.centerBtns.prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.centerBtns.next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.big_prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.big_next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.centerBtns.pageInput_mc.pageInput_txt.restrict = "0-9";
			toolBar.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			toolBar.addEventListener(MouseEvent.ROLL_OVER, onToolBarRollOverHandler);
			toolBar.addEventListener(MouseEvent.ROLL_OUT, onToolBarRollOutHandler);
			resize();
		}

		private function onToolBarRollOverHandler(e:MouseEvent):void {
			if (e.target.name == "big_prev_btn" || e.target.name == "big_next_btn") {
				return;
			}
			trace("onToolBarRollOverHandler " + e.target);
			trace("onToolBarRollOverHandler " + e.target.name);
			TweenLite.killTweensOf(toolBar);
			TweenLite.to(toolBar.centerBtns, 0.5, {alpha: 1});
			TweenLite.to(toolBar.logo, 0.5, {alpha: 1});
			TweenLite.to(toolBar.bg, 0.5, {alpha: 1});
		}

		private function onToolBarRollOutHandler(e:MouseEvent):void {
			if (e.target.name == "big_prev_btn" || e.target.name == "big_next_btn") {
				return;
			}
			trace("onToolBarRollOutHandler " + e.target);
			trace("onToolBarRollOutHandler " + e.target.name);
			TweenLite.killTweensOf(toolBar);
			TweenLite.to(toolBar.centerBtns, 0.5, {alpha: 0});
			TweenLite.to(toolBar.logo, 0.5, {alpha: 0});
			TweenLite.to(toolBar.bg, 0.5, {alpha: 0});
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible = false;
			toolBar.centerBtns.bookName_mc.openPanel_spr.visible = false;
		}

		private function onClickQieHuanMCHandler(e:MouseEvent):void {
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible = !toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible;
			if (toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible) {
				toolBar.bg.removeEventListener(MouseEvent.MOUSE_OUT, onToolBarRollOutHandler);
			} else {
				toolBar.bg.addEventListener(MouseEvent.MOUSE_OUT, onToolBarRollOutHandler);
			}
		}

		private function onFocusInHandler(e:FocusEvent):void {
			toolBar.centerBtns.pageInput_mc.pageInput_txt.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			toolBar.centerBtns.pageInput_mc.pageInput_txt.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
		}

		private function onKeyDownHandler(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case Keyboard.ENTER:
					onInputOver(e.target.text);
					break;
				default :
					break;
			}
		}

		private function onFocusOutHandler(e:FocusEvent):void {
			onInputOver(e.target.text);
		}

		private function onInputOver(s:String):void {
			toolBar.centerBtns.pageInput_mc.pageInput_txt.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownHandler);
			toolBar.centerBtns.pageInput_mc.pageInput_txt.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			var n:int = int(s);
			if (n < 1) {
				n = 1;
			} else if (n > int(toolBar.centerBtns.pageInput_mc.pageTotal_txt.text)) {
				n = toolBar.centerBtns.pageInput_mc.pageTotal_txt.text;
			}
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "page", data: n}));
		}

		public function setTotalPage(p:int):void {
			toolBar.centerBtns.pageInput_mc.pageTotal_txt.text = String(p);
		}

		public function setCurrentPage(p:int):void {
			toolBar.centerBtns.pageInput_mc.pageInput_txt.text = String(p);
		}

		private function onClickLogoBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "logo"}));
		}

		private function onClickBookNameBtnHandler(e:MouseEvent):void {
			toolBar.centerBtns.bookName_mc.openPanel_spr.visible = !toolBar.centerBtns.bookName_mc.openPanel_spr.visible;
			if (toolBar.centerBtns.bookName_mc.openPanel_spr.visible) {
				toolBar.bg.removeEventListener(MouseEvent.MOUSE_OUT, onToolBarRollOutHandler);
			} else {
				toolBar.bg.addEventListener(MouseEvent.MOUSE_OUT, onToolBarRollOutHandler);
			}
		}

		private function onClickDatiBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "dati"}));
		}

		private function onClickSingleBtnHandler(e:MouseEvent):void {
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible = false;
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "single"}));
		}

		private function onClickDoubleBtnHandler(e:MouseEvent):void {
			toolBar.centerBtns.qiehuan_mc.openPanel_spr.visible = false;
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "double"}));
		}

		private function onClickZoomInBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "zoomIn"}));
		}

		private function onClickZoomOutBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "zoomOut"}));
		}

		private function onClickHuanYuanBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "huanyuan"}));
		}

		private function onClickPrevBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "prev"}));
		}

		private function onClickNextBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "next"}));
		}

		public function resize():void {
			toolBar.bg.width = PageContainer.stageW;
			toolBar.kongbai_mc.width = PageContainer.stageW;
			toolBar.big_prev_btn.x = 20;
			toolBar.big_next_btn.x = PageContainer.stageW - 20 - toolBar.big_next_btn.width;
			DisObjUtil.toStageYCenter(toolBar.big_next_btn);
			DisObjUtil.toStageYCenter(toolBar.big_prev_btn);
			DisObjUtil.toStageXCenter(toolBar.centerBtns);
		}

		public function setBookName(s:String):void {
			toolBar.centerBtns.bookName_mc.bookName_btn.bookName.text = s;
		}

		public function setDatiBtnVisible(b:Boolean):void {
			toolBar.centerBtns.dati_btn.visible = b;
		}

		public function changeModeTypeString():void {
			var s:String;
			if (ConfigManager.pageMode == PageMode.SINGLE) {
				s = "单页";
			} else if (ConfigManager.pageMode == PageMode.DOUBLE) {
				s = "双页";
			}
			toolBar.centerBtns.qiehuan_mc.qiehuan_btn.upState.getChildAt(2).text = s;
			toolBar.centerBtns.qiehuan_mc.qiehuan_btn.overState.getChildAt(2).text = s;
			toolBar.centerBtns.qiehuan_mc.qiehuan_btn.downState.getChildAt(2).text = s;
		}

		public function setNeighbor(neighbor:Vector.<OtherBookInfo>):void {
			var btn:UI_OldBookBtn;
			for (var j:int = 0; j < toolBar.centerBtns.bookName_mc.openPanel_spr.container.numChildren; j++) {
				btn = toolBar.centerBtns.bookName_mc.openPanel_spr.container.getChildAt(j);
				btn.removeEventListener(MouseEvent.CLICK, onClickOldBookBtnHandler);
				btn.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverOtherBookBtnBtnHandler);
				btn.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutOtherBookBtnBtnHandler);
				toolBar.centerBtns.bookName_mc.openPanel_spr.container.removeChild(btn)
			}
			DisObjUtil.removeAllChildren(toolBar.centerBtns.bookName_mc.openPanel_spr.container);
			//
			toolBar.centerBtns.bookName_mc.openPanel_spr.btnGroup_bg.height = 0;
			var th:Number = 3;
			var sh:Number = 28;
			var otherBookName:String;
			var otherBookInfo:OtherBookInfo;
			for (var i:String in neighbor) {
				otherBookInfo = neighbor[i];
				otherBookName = otherBookInfo.gradeName + "(" + otherBookInfo.version + ")" + " " + otherBookInfo.year + "年 第" + otherBookInfo.perNum + "期";
				btn = new UI_OldBookBtn();
				btn.name = otherBookInfo.id;
				btn.bookName_txt.text = otherBookName;
				btn.buttonMode = true;
				btn.mouseChildren = false;
				btn.x = 6;
				btn.y = th;
				th += sh + 2;
				if (otherBookInfo.id == BookManager.bookInfo.id) {
					btn.alpha = 0.7;
				} else {
					btn.addEventListener(MouseEvent.CLICK, onClickOldBookBtnHandler);
					btn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverOtherBookBtnBtnHandler);
					btn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutOtherBookBtnBtnHandler);
				}
				toolBar.centerBtns.bookName_mc.openPanel_spr.container.addChild(btn);
			}
			toolBar.centerBtns.bookName_mc.openPanel_spr.btnGroup_bg.height = th + 2;
		}

		private function onMouseOutOtherBookBtnBtnHandler(e:MouseEvent):void {
			e.currentTarget.x = 6;
		}

		private function onMouseOverOtherBookBtnBtnHandler(e:MouseEvent):void {
			e.currentTarget.x = 8;
		}

		private function onClickOldBookBtnHandler(e:MouseEvent):void {
			toolBar.centerBtns.bookName_mc.openPanel_spr.visible = false;
			ConfigManager.loadBookData(e.currentTarget.name);
			ExternalInterface.call("flashCallJs", "huanShu", e.currentTarget.name);
		}
	}
}
