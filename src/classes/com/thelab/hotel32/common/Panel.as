﻿package com.thelab.hotel32.common{	import com.greensock.TweenMax;	import com.greensock.easing.Circ;	import com.thelab.hotel32.assets.PanelAsset;	import com.thelab.hotel32.helpers.Logger;		import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.text.TextField;		import org.osflash.signals.Signal;
		public class Panel extends Sprite	{				private var pageData						: XMLList;		private var tabArray						: Array;		private var _selectedTab					: Tab;				public var paginatorReady					: Signal;		public var selectedSender					: Signal;				private var asset							: MovieClip;		public var paginator						: Paginator;				private var headline						: PanelHeadline;		private var body							: PanelCopy;				private var _active							: Boolean;				public function Panel(name:String, data:XMLList)		{			this.name = name;			this.pageData = data;			x = 749;			y = 19;						paginatorReady = new Signal();			selectedSender = new Signal();						if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }		}				private function init(e:Event=null):void		{			removeEventListener(Event.ADDED_TO_STAGE, init);						asset = new PanelAsset();			addChild(asset);						headline = new PanelHeadline();			addChild(headline);			headline.changed.add(adjustText);			headline.text = Utils.stringToHTML(pageData..headline.toString());						body = new PanelCopy();			addChild(body);			body.changed.add(adjustText);			body.text = Utils.stringToHTML(pageData..copy.toString());									paginator = new Paginator(this.name + "-Paginator");			addChild(paginator);			paginator.x = 312;			paginator.y = 380;			paginator.count = pageData..images.image.length();						active = false;						paginatorReady.dispatch();		}				private function adjustText():void		{			if (body) { body.y = headline.y + headline.height + 20; }		}					public function get active():Boolean		{			return _active;		}				public function set active(val:Boolean):void		{			_active = val;			if (_active)			{				paginator.show();			}			else			{				paginator.hide();			}		}				public function hide():void		{			TweenMax.to(this, .25, { autoAlpha: 0 } );			active = false;		}				public function show():void		{			TweenMax.to(this, .25, { autoAlpha: 1 } );			active = true;		}				override public function toString():String		{			return "[Panel id: " + name + "]";		}	}}