package utils.common.util {

	import com.adobe.serialization.json.JSON;

	import events.TBZBEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	public class LoadUtil extends EventDispatcher {
		private var loader:URLLoader;
		private var eventType:String;
		private var saveType:String;

		public function LoadUtil():void {
			super();
		}

		public function load(listener:String, url:String, _data:* = null, _method:String = "post", type:String = "data", _saveType:String = ""):void {
			eventType = listener;
			saveType = _saveType;
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			var urlvVaraible:URLVariables = new URLVariables();
			if (_data != null) {
				for (var j:String in _data) {
					trace("打包上传的" + j + ":" + _data[j]);
					urlvVaraible[j] = _data[j];
				}
			} else {
				urlvVaraible.value = "";
			}
			var _request:URLRequest = new URLRequest();
			if (_method == "POST" || _method == "post") {
				_request.method = URLRequestMethod.POST;
			} else {
				_request.method = URLRequestMethod.GET;
			}
			_request.url = url;
			if (type == "bitmap") {
				var data:ByteArray = new ByteArray();
				data.writeUTFBytes('--AMIN2312\r\nContent-Disposition: form-data; name="img"; filename="img.jpg"\r\nContent-Type: application/octet-stream\r\n\r\n');
				data.writeBytes(_data);
				data.writeUTFBytes('\r\n');
				data.writeUTFBytes('--AMIN2312--');
				_request.requestHeaders.push(new URLRequestHeader('Content-Type', 'multipart/form-data; boundary=AMIN2312'));
				_request.data = data;
			} else {
				_request.data = urlvVaraible;
			}
			loader.load(_request);
		}

		private function onComplete(e:Event):void {
			var str:String = loader.data;
			callBackData(str);
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorEvent);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorEvent);
			loader = null;
		}

		private function onIOErrorEvent(e:IOErrorEvent):void {
			trace("IOErrorHandler: " + e.toString());
			errorData(-101);
		}

		private function onSecurityErrorEvent(e:SecurityErrorEvent):void {
			trace("SecurityErrorEvent: " + e.toString());
			errorData(-101);
		}

		private function callBackData(s:String):void {
			try {
				var o:Object = com.adobe.serialization.json.JSON.decode(s);
				o.saveType = saveType;
				this.dispatchEvent(new TBZBEvent(eventType, o));
			} catch(e:Error) {
				errorData(-100);
			}
		}

		private function errorData(err:int):void {
			trace("load错误");
			var o:Object = new Object();
			o.status = err;
			this.dispatchEvent(new TBZBEvent(eventType, o));
		}
	}
}
