﻿package com.thelab.hotel32.helpers{		import com.greensock.TweenMax;	import com.thelab.hotel32.assets.AssetLoader;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.TimerEvent;	import flash.utils.Timer;
		public class AssetLoadTest extends Sprite	{		public static const FACE_ASSET					: String = "assets/swf/face.swf";		public static const HOUSE_ASSET					: String = "assets/swf/house.swf";		public static const LIBRARY_ASSET				: String = "assets/swf/library.swf";				public function AssetLoadTest()		{			AssetLoader.getInstance().load(FACE_ASSET, callbackFn);			AssetLoader.getInstance().load(HOUSE_ASSET, otherCallback);			AssetLoader.getInstance().load(LIBRARY_ASSET, libraryCallback);						var myTimer:Timer = new Timer(3000);			myTimer.addEventListener(TimerEvent.TIMER, delayedLoad);			myTimer.start();		}				private function delayedLoad(e:TimerEvent):void		{			trace("\n\ntimer...\n\n");			e.target.stop();			AssetLoader.getInstance().load(FACE_ASSET, duplicateCallback);		}				public function callbackFn(e:Event):void		{			trace("face loaded");			var asset:MovieClip = AssetLoader.getInstance().loader.getMovieClip(FACE_ASSET);			addChild(asset);			asset.x = asset.y = 100;					}				public function otherCallback(e:Event):void		{			trace("house loaded...");			var asset:MovieClip = AssetLoader.getInstance().loader.getMovieClip(HOUSE_ASSET);			addChild(asset);			asset.x = 400;			asset.y = 100;		}				public function duplicateCallback(e:Event):void		{			var asset:MovieClip = AssetLoader.getInstance().loader.getMovieClip(FACE_ASSET);			trace("got duplicate face asset: " + asset);			asset.x = 600;			asset.y = 200;			addChild(asset);		}				public function libraryCallback(e:Event):void		{			trace("got library asset");						var tempClass:Class = AssetLoader.getInstance().loader.getMovieClip(LIBRARY_ASSET).loaderInfo.applicationDomain.getDefinition("com.thelab.throbber") as Class;			var throbber:MovieClip = new tempClass() as MovieClip;			throbber.x = 50;			throbber.y = 50;			addChild(throbber);						tempClass = AssetLoader.getInstance().loader.getMovieClip(LIBRARY_ASSET).loaderInfo.applicationDomain.getDefinition("com.thelab.textasset") as Class;			var textAsset:MovieClip = new tempClass() as MovieClip;			textAsset.x = 350;			textAsset.y = 350;			textAsset.alpha = 0;			addChild(textAsset);			TweenMax.to(textAsset, 5, { alpha: 1 });		}	}}