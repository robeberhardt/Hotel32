﻿package com.thelab.hotel32.views{	import com.greensock.TweenMax;	import com.thelab.hotel32.booking.BookingButton;	import com.thelab.hotel32.booking.BookingController;	import com.thelab.hotel32.nav.LegalCopy;	import com.thelab.hotel32.nav.Logo;	import com.thelab.hotel32.nav.NavigationController;	import com.thelab.hotel32.nav.PhoneNumber;	import com.thelab.hotel32.nav.TopNavBar;	import com.thelab.hotel32.nav.TopNavButton;		import flash.display.DisplayObject;	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.geom.Point;		import org.osflash.signals.natives.NativeSignal;
		public class AppStage extends MovieClip	{		private static var instance					: AppStage;		private static var allowInstantiation		: Boolean;				public static const PUBLISH_WIDTH			: Number = 1194;		public static const PUBLISH_HEIGHT			: Number = 698;		public static const MIN_WIDTH				: Number = 1030;		public static const MIN_HEIGHT				: Number = 640;				public var viewHolder						: Sprite;//		public var bookingController				: BookingController;		//public var bookingShield					: BookingShield;								public function AppStage(name:String = "AppStage")		{			if (!allowInstantiation) {				throw new Error("Error: Instantiation failed: Use AssetLoader.getInstance()");			} else {				this.name = name;				if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }			}		}				public static function getInstance(name:String = "AppStage"):AppStage {			if (instance == null) {				allowInstantiation = true;				instance = new AppStage(name);				allowInstantiation = false;			}			return instance;		}							private function init(e:Event=null):void		{			removeEventListener(Event.ADDED_TO_STAGE, init);					var myPageBackground : PageBackground = new PageBackground();			addChild(myPageBackground);						viewHolder = new ViewHolder();			addChild(viewHolder);				var legalCopy : LegalCopy = NavigationController.getInstance().legalCopy;			addChild(legalCopy);						var phoneNumber : PhoneNumber = NavigationController.getInstance().phoneNumber;			addChild(phoneNumber);						//			bookingController = new BookingController();//			addChild(bookingController);						var logo:Logo = NavigationController.getInstance().logo;			addChild(logo);									//			bookingShield = new BookingShield();//			addChild(bookingShield);			//			bookingShield.x 					stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);			stage.dispatchEvent(new Event(Event.RESIZE));			}				public function addBookingControllerToStage(controller:BookingController):void		{			addChildAt(controller, numChildren - 2);			}				public function setup():void		{					}			public function addToStage(view:BasicView):void		{			viewHolder.addChildAt(view, 0);		}				public function removeFromStage(view:BasicView):void		{			viewHolder.removeChild(view);		}				private function onStageResize(e:Event=null):void		{			var w:int = stage.stageWidth;			var h:int = stage.stageHeight;										if (w < PUBLISH_WIDTH)			{				x = Math.round((PUBLISH_WIDTH-w)*.5) - (PUBLISH_WIDTH - w);				if (w < MIN_WIDTH + Math.round((PUBLISH_WIDTH - MIN_WIDTH)*.5))				{					x += (MIN_WIDTH - w) + Math.round((PUBLISH_WIDTH-MIN_WIDTH)*.5);				}			}				else			{				x = 0;			}						if (h < PUBLISH_HEIGHT)			{				y = Math.round((PUBLISH_HEIGHT - h) * .5 - (PUBLISH_HEIGHT - h));				if (y < -15) { y = -15; }							}				else			{				y = 0;			}		}				public function get center():Point		{			return new Point(Math.round(PUBLISH_WIDTH * .5), Math.round(PUBLISH_HEIGHT * .5)-101);		}				public function get min():Point		{			return new Point(stage.stageWidth - AppStage.PUBLISH_WIDTH, stage.stageHeight - AppStage.PUBLISH_HEIGHT);		}	}}