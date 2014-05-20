/**
 * Created with 工具栏管理器.
 * User: zhishaofei
 * Date: 2014-5-14
 * Time: 13:53
 */
package core {
	import events.UIEvent;

	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
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
			toolBar.logo.addEventListener(MouseEvent.CLICK, onClickLogoBtnHandler);
			toolBar.centerBtns.single_btn.addEventListener(MouseEvent.CLICK, onClickSingleBtnHandler);
			toolBar.centerBtns.double_btn.addEventListener(MouseEvent.CLICK, onClickDoubleBtnHandler);
			toolBar.centerBtns.zoomIn_btn.addEventListener(MouseEvent.CLICK, onClickZoomInBtnHandler);
			toolBar.centerBtns.zoomOut_btn.addEventListener(MouseEvent.CLICK, onClickZoomOutBtnHandler);
			toolBar.centerBtns.huanyuan_btn.addEventListener(MouseEvent.CLICK, onClickHuanYuanBtnHandler);
			toolBar.centerBtns.prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.centerBtns.next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.big_prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.big_next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.centerBtns.pageInput_mc.pageInput_txt.restrict = "0-9";
			toolBar.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			resize();
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

		private function onClickSingleBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "single"}));
		}

		private function onClickDoubleBtnHandler(e:MouseEvent):void {
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
			toolBar.big_prev_btn.x = 20;
			toolBar.big_next_btn.x = PageContainer.stageW - 20 - toolBar.big_next_btn.width;
			DisObjUtil.toStageYCenter(toolBar.big_next_btn);
			DisObjUtil.toStageYCenter(toolBar.big_prev_btn);
			DisObjUtil.toStageXCenter(toolBar.centerBtns);
		}

		public function setBookName(s:String):void {
			toolBar.centerBtns.bookName.text = s;
		}
	}
}
