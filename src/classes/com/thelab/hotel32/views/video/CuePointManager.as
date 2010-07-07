package com.thelab.hotel32.views.video
{
	import com.greensock.TweenMax;
	import com.greensock.loading.SWFLoader;
	import com.thelab.hotel32.assets.AssetController;
	import com.thelab.hotel32.helpers.DebugConsole;
	import com.thelab.hotel32.helpers.TrackEvent;
	import com.thelab.hotel32.helpers.Tracker;
	import com.thelab.hotel32.nav.NavigationController;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.sampler.getInvocationCount;
	
	public class CuePointManager extends Sprite
	{
		private var _data										: XMLList;
		private var _videoDuration								: Number;
		private var cpArray										: Array;
		private var tempClass									: Class;
		private var assetLoader									: SWFLoader;
		
		private var currentCuePoint								: CuePoint;
				
		private var myCuePointTag								: CuePointTag;
		
		private var _automaticTag								: Boolean = true;		
		
		public static const CUEPOINT_TAG_CLICKED				: String = "CUEPOINT_TAG_CLICKED";
		private static const CUE_POINT_THRESHOLD				: Number = 2;
		public static const BAR_WIDTH							: Number = 978;
		
		public function CuePointManager(loader:SWFLoader, videoDuration:Number, data:XMLList, yPos:Number)
		{
			assetLoader = loader;
			_videoDuration = videoDuration;
			_data = data;
			
			cpArray = new Array();

			for (var i:int = 0; i < _data.length(); i++) 
			{
				
				tempClass = assetLoader.getClass("com.thelab.hotel32.video.cuepointasset");
				var cuepointAsset:MovieClip = new tempClass() as MovieClip;
				
				var cp:CuePoint = new CuePoint(cuepointAsset, _data[i]);
				cp.index = i;
				cp.addEventListener(CuePoint.CUE_POINT_ROLLOVER, onCuePointRollOver, false, 0, true);
				cp.addEventListener(CuePoint.CUE_POINT_ROLLOUT, onCuePointRollOut, false, 0, true);
				cp.addEventListener(CuePoint.CUE_POINT_CLICKED, onCuePointClicked, false, 0, true);
				addChild(cp);
				cpArray.push(cp);
				
				cp.x = Math.round((cp.time * BAR_WIDTH) / _videoDuration);
				cp.y = yPos + 1;
			}
			
		
			tempClass = assetLoader.getClass("com.thelab.hotel32.video.cptag");
			var cptagAsset:MovieClip = new tempClass() as MovieClip;
			
			myCuePointTag = new CuePointTag(assetLoader);
			addChild(myCuePointTag);
			myCuePointTag.addEventListener(CuePointTag.CUEPOINT_TAG_ROLLOVER, onTagRollover, false, 0, true);
			myCuePointTag.addEventListener(CuePointTag.CUEPOINT_TAG_ROLLOUT, onTagRollout, false, 0, true);
			myCuePointTag.addEventListener(CuePointTag.CUEPOINT_TAG_CLICKED, onTagClicked, false, 0, true);
			myCuePointTag.y = 80;
			
		}
		
		private function onCuePointRollOver(e:Event):void
		{
			if (currentCuePoint) { currentCuePoint.shrink(); }
			currentCuePoint = CuePoint(e.target);
			TweenMax.killDelayedCallsTo(restoreAutomatic);
			_automaticTag = false;
			myCuePointTag.reset();
			tagSetup(currentCuePoint);
			myCuePointTag.show();
		}
		
		private function onCuePointRollOut(e:Event):void
		{
			TweenMax.delayedCall(.5, restoreAutomatic);
		}
		
		private function restoreAutomatic():void
		{
			_automaticTag = true;
		}
		
		private function onCuePointClicked(e:Event):void
		{
			// remember, this event is bubbling up to VideoPlayer
			myCuePointTag.reset();
			for each (var cp:CuePoint in cpArray)
			{
				cp.forceShrink();
			}
		}
		
		private function onTagRollover(e:Event):void
		{
			TweenMax.killDelayedCallsTo(restoreAutomatic);
			_automaticTag = false;
		}
		
		private function onTagRollout(e:Event):void
		{
			TweenMax.delayedCall(.5, restoreAutomatic);
		}
		
		private function onTagClicked(e:Event):void
		{
			var theCuePoint:CuePoint = cpArray[myCuePointTag.currentCuePointIndex] as CuePoint;
			Tracker.getInstance().track(theCuePoint.toString());
			Tracker.getInstance().track(TrackEvent.TOOLTIP + "/" + theCuePoint.id);
			NavigationController.getInstance().navigateToView(ViewController.getInstance().getViewFromName("amenities"), theCuePoint.id, NavigationController.HISTORY_MODE_PAGE);
		}
		
		
		public function testCuepoint(t:Number):void
		{
			if (_automaticTag)
			{
				
				var closestVal : Number = 99999;
				var closestIndex : int = 0;
				for (var i:int = 0; i < cpArray.length; i++)
				{
					var temp:Number = Math.abs(t - cpArray[i].time);
					if (temp < closestVal) 
					{ 
						closestVal = temp;
						closestIndex = i;
					}
					
					
				}
				
				var theCuePoint:CuePoint = cpArray[closestIndex] as CuePoint;
				
				if (Math.abs(cpArray[closestIndex].time - t) < CUE_POINT_THRESHOLD )
				{				
					if (!myCuePointTag.showing)
					{
						tagSetup(theCuePoint);
						myCuePointTag.show();
						currentCuePoint = theCuePoint;
					}
					else
					{
						if (myCuePointTag.currentCuePoint != theCuePoint)
						{
							myCuePointTag.reset();
							for each (var cp:CuePoint in cpArray)
							{
								cp.forceShrink();
								currentCuePoint = null;
							}
						}
					}
				}
				else	
				{
					myCuePointTag.hide();	
					currentCuePoint = null;
				}
				
			}
			
		}
		
		private function tagSetup(cp:CuePoint):void
		{
			myCuePointTag.currentCuePoint = cp;
			myCuePointTag.x = cp.x;
			myCuePointTag.y = cp.y - 14;
			myCuePointTag.labeltext = cp.title;
			myCuePointTag.currentCuePointIndex = cp.index;
		}
		
		public function checkCuePointsForActivation(loadedPercent:Number):void
		{
			for (var i:int = 0; i < cpArray.length; i++)
			{
				
				var loadedTime:Number = loadedPercent * _videoDuration;
				if ( loadedTime > cpArray[i].time && !cpArray[i].active)
				{
					cpArray[i].active = true;
				}
			}
		}
		
		public function activateAllCuePoints():void
		{
			for (var i:int = 0; i < cpArray.length; i++)
			{
				if (!cpArray[i].active)
				{
					cpArray[i].active = true;
				}
			}
		}
		
		public function resetAllCuePoints():void
		{
			for (var i:int = 0; i < cpArray.length; i++)
			{
				CuePoint(cpArray[i]).reset();
			}
		}
		
		private function getURL(url:String, target:String=null):void
		{
			try 
			{
				navigateToURL(new URLRequest(url), target);
			}
			catch (e:Error)
			{
				//	
			}
		}
	}
}