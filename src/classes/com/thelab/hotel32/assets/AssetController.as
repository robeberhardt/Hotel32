package com.thelab.hotel32.assets
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.*;
	import com.greensock.loading.display.*;
	import com.thelab.hotel32.helpers.Logger;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;

	public class AssetController extends Sprite
	{
		private static var instance					: AssetController;
		private static var allowInstantiation		: Boolean;
		
		public var configLoaded						: Signal;
		
		public var configXML						: XML;
		
		private var _volumeLevel					: Number;
		private var _previousVolumeLevel			: Number;
		private var _savedDate						: String;
		private var _savedNights					: Number;
		private var _savedTime						: Date;
		
		public var queue							: LoaderMax;
		private var callbackDict					: Dictionary;
		public var basePath							: String;
		private var callbackFunction				: Function;
		
		private var fvDict							: Dictionary;
		
		public var fvMainConfig						: String;
		
		public static const FV_MAIN_CONFIG			: String = "mainconfig"
		
		public static const ASSETS_INITIALIZED		: String = "ASSETS_INITIALIZED";
		
		public static const CUE_POINT_ASSET			: String = "com.thelab.hotel32.cuepointasset";
		public static const CUE_POINT_TAG_ASSET		: String = "com.thelab.hotel32.cptag";
		
		public var so								: SharedObject;
		public static const SHARED_OBJECT_NAME		: String = "hotel32_cookie";
		
		
		
		public function AssetController(name:String = "AssetController")
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use AssetLoader.getInstance()");
			} else {
				this.name = name;
				init();
			}
		}
		
		public static function getInstance(name:String = "AssetController"):AssetController {
			if (instance == null) {
				allowInstantiation = true;
				instance = new AssetController(name);
				allowInstantiation = false;
			}
			return instance;
		}
		
		private function init():void
		{
			configLoaded = new Signal();
			initSharedObject();
			queue = new LoaderMax( {name:"loader", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler} );
		}
		
		private function loadConfigXML():void
		{
			Logger.log("fvMainConfig: " + fvMainConfig);
			queue.append( new XMLLoader(fvMainConfig, { noCache: true, autoDispose: true } ));
			queue.load();
		}
		
		private function progressHandler(e:LoaderEvent):void
		{
			//
		}
		
		private function completeHandler(e:LoaderEvent):void
		{
			configXML = queue.getContent(fvMainConfig);
			basePath = configXML..paths.assets.url.toString() + "/";
			configLoaded.dispatch();
		}
		
		private function errorHandler(e:LoaderEvent):void
		{
			trace("error occured with " + e.target + ": " + e.text);
		}
		
		private function initSharedObject():void
		{
			so = SharedObject.getLocal(SHARED_OBJECT_NAME);
			
			_volumeLevel = so.data.volumeLevel;
			// TODO: Take this temporary mute out
			// FOR DEBUG ONLY
			_volumeLevel = 0;
			
			if (!_volumeLevel)
			{
				Logger.log("   --> there was nothing in the shared object :(");
				so.data.volumeLevel = 1;
				so.flush();
			}
			else
			{
				Logger.log("   --> volumeLevel loaded from shared object: " + _volumeLevel);
			}
			
			_previousVolumeLevel = so.data.previousVolumeLevel;
			if (!_previousVolumeLevel)
			{
				so.data.previousVolumeLevel = 1;
				so.flush();
			}
			
			
			
		}

		public function loadFlashvars(paramObj:Object):void
		{
			fvDict = new Dictionary();
			
			for (var keyStr:String in paramObj)
			{
				var valueStr:String = String(paramObj[keyStr]);
				fvDict[keyStr]= valueStr;
			}
			
			fvMainConfig = fvDict[FV_MAIN_CONFIG];
			
			if (fvMainConfig == null)
			{
				fvMainConfig = "config.xml";
			}
			
			loadConfigXML();
		}
		
	
		
		public function writeVolumeToSO():void
		{
			trace("writing volume to so");
			so.data.volumeLevel = _volumeLevel;
			so.flush();
		}
		
		//SO saved dates
		public function get savedDate():String{
			_savedDate = so.data.savedDate;
			return _savedDate;
		}
		public function set savedDate(dateStr:String):void{
			_savedDate = dateStr;
			so.data.savedDate = _savedDate;
			so.flush();
		}
		//SO saved nights selected
		public function get savedNights():Number{
			_savedNights = so.data.savedNights;
			return _savedNights;
		}
		public function set savedNights(value:Number):void{
			_savedNights = value;
			so.data.savedNights = _savedNights;
			so.flush();
		}
		//save date object for comparing date last clicked
		//
		public function get savedTime():Date{
			_savedTime = so.data.savedTime;
			return _savedTime;
		}
		public function set savedTime(d:Date):void{
			_savedTime = d;
			so.data.savedTime = _savedTime;
			so.flush();
		}
		
		public function get volumeLevel():Number
		{
			return _volumeLevel;
		}
		
		public function set volumeLevel(value:Number):void
		{
			_volumeLevel = value;
		}
		
		public function get previousVolumeLevel():Number
		{
			return _previousVolumeLevel;
		}
		
		public function set previousVolumeLevel(value:Number):void
		{
			_previousVolumeLevel = value;
		}
	}
}