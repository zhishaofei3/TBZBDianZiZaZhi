/**
 * Created with 工具栏管理器.
 * User: zhishaofei
 * Date: 2014-5-14
 * Time: 13:53
 */
package core {
	import events.UIEvent;

	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	import scenes.LayerManager;

	import utils.common.util.DisObjUtil;

	public class ToolBarManager extends EventDispatcher {
		private var toolBar:UI_ToolBar;

		public function ToolBarManager() {
			toolBar = new UI_ToolBar();
			toolBar.alpha = 0.5;
			LayerManager.toolContainer.addChild(toolBar);
			toolBar.single_btn.addEventListener(MouseEvent.CLICK, onClickSingleBtnHandler);
			toolBar.double_btn.addEventListener(MouseEvent.CLICK, onClickDoubleBtnHandler);
			toolBar.zoomIn_btn.addEventListener(MouseEvent.CLICK, onClickZoomInBtnHandler);
			toolBar.zoomOut_btn.addEventListener(MouseEvent.CLICK, onClickZoomOutBtnHandler);
			toolBar.prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.big_prev_btn.addEventListener(MouseEvent.CLICK, onClickPrevBtnHandler);
			toolBar.big_next_btn.addEventListener(MouseEvent.CLICK, onClickNextBtnHandler);
			toolBar.close_btn.addEventListener(MouseEvent.CLICK, onClickCloseBtnHandler);
			resize();
		}

		public function setTotalPage(p:int):void {
			toolBar.pageInput_mc.pageTotal_txt.text = String(p);
		}

		public function setCurrentPage(p:int):void {
			toolBar.pageInput_mc.pageInput_txt.text = String(p);
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

		private function onClickPrevBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "prev"}));
		}

		private function onClickNextBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "next"}));
		}

		private function onClickCloseBtnHandler(e:MouseEvent):void {
			dispatchEvent(new UIEvent(UIEvent.TOOLBARMANAGER_EVENT, {type: "close"}));
		}

		public function resize():void {
			toolBar.close_btn.x = PageContainer.stageW - toolBar.close_btn.width - 10;
			toolBar.bg.width = PageContainer.stageW;
			toolBar.big_prev_btn.x = 20;
			toolBar.big_next_btn.x = PageContainer.stageW - 20 - toolBar.big_next_btn.width;
			DisObjUtil.toStageYCenter(toolBar.big_next_btn);
			DisObjUtil.toStageYCenter(toolBar.big_prev_btn);
		}
	}
}
