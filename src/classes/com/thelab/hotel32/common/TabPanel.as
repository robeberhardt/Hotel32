package com.thelab.hotel32.common
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.thelab.hotel32.assets.TabBorderAsset;
	import com.thelab.hotel32.assets.TabPanelAsset;
	import com.thelab.hotel32.common.Tab;
	import com.thelab.hotel32.helpers.BasicButton;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.tabbox.PageButtonClip;
	import com.thelab.hotel32.views.rooms.RoomsGridThumbButton;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.osflash.signals.Signal;
	
	public class TabPanel extends Sprite
	{
		private var pageData						: XMLList;
		private var tabArray						: Array;
		private var _selectedTab					: Tab;
		
		public var paginatorReady					: Signal;
		public var selectedSender					: Signal;
		public var thumbSender						: Signal;
		
		private var asset							: MovieClip;

		public var paginator						: Paginator;
		private var border							: MovieClip;
		
		private var copyHolder						: Sprite;
		private var headline						: PanelHeadline;
		private var body							: PanelCopy;
		
		private var thumbButton						: RoomsGridThumbButton;
		
		public function TabPanel(name:String, pageXML:XMLList)
		{
			this.name = name;
			this.pageData = pageXML..tabs;
			
			Logger.log("there are " + pageData..tab.length() + " tabs");
			tabArray = new Array();
			visible = false;
			alpha = 0;
			x = 1400;
			y = 56;
			
			paginatorReady = new Signal();
			thumbSender = new Signal();
			selectedSender = new Signal();
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			asset = new TabPanelAsset();
			addChild(asset);
//			headlineCopy = asset.copyHolder.headline;
//			bodyCopy = asset.copyHolder.body;
			
			copyHolder = new Sprite();
			addChild(copyHolder);
			
			headline = new PanelHeadline();
			copyHolder.addChild(headline);
			headline.changed.add(adjustText);
			headline.text = Utils.stringToHTML(pageData..headline.toString());
			
			body = new PanelCopy();
			copyHolder.addChild(body);
			body.changed.add(adjustText);
			body.text = Utils.stringToHTML(pageData..copy.toString());
			
			for (var i:int=0; i<pageData..tab.length(); i++)
			{
				Logger.log("creating tab " + i, 5);
				var tab:Tab = new Tab(pageData..tab[i].@id.toString());
				tab.index = i+1;
				tab.x = i*86 + i;
				addChild(tab);
				tabArray.push(tab);
				tab.clickedSender.add(onTabClicked);
			}
			
			
			border = new TabBorderAsset();
			border.gotoAndStop(1);
			addChild(border);
			
			
//			headlineCopy.background = false;
//			headlineCopy.border = false;
//			bodyCopy.background = false;
//			bodyCopy.border = false;
			
			thumbButton = new RoomsGridThumbButton("thumb");
			thumbButton.x = 38;
			thumbButton.y = 350;
			thumbButton.clickedSender.add(onThumbButtonClicked);
			addChild(thumbButton);
			
			paginator = new Paginator(this.name + "-Paginator");
			addChild(paginator);
			paginator.x = 312;
			paginator.y = 350;
			
			paginatorReady.dispatch();
			
		}
		
		private function onThumbButtonClicked(which:BasicButton):void
		{
			//Logger.log("YOU CLICKED THE THUMB");
			thumbSender.dispatch();
		}
		
		public function selectByName(val:String):void
		{
			//Logger.log("\nselectByName: " + val, 3);
			for (var i:uint = 0; i<tabArray.length; i++)
			{
				var tab:Tab = tabArray[i] as Tab;
				if (tab.name == val)
				{
					Logger.log("selectByName: selecting " + tab, 4);
					selectedTab = tab;
				}
			}
		}
		
		public function refreshContent():void
		{
//			Logger.log("pageCount: " + pageData..tab[selectedTab.index-1]..images.image.length());
//			paginator.count = uint(pageData..tab[selectedTab.index-1]..images.image.length());
			Logger.log("REFRESHING CONTENT");
//			headlineCopy.htmlText = Utils.stringToHTML( pageData..tab[selectedTab.index-1]..headline.toString() );
//			bodyCopy.htmlText = Utils.stringToHTML( pageData..tab[selectedTab.index-1]..copy.toString() );
			
			headline.text = Utils.stringToHTML( pageData..tab[selectedTab.index-1]..headline.toString() );
			body.text = Utils.stringToHTML( pageData..tab[selectedTab.index-1]..copy.toString() );
			
			TweenMax.to(copyHolder, .4, { autoAlpha: 1 } );
			paginator.show();
			
		}
		
//		public function showCopyHolder():void
//		{
//			TweenMax.to(box.copyHolder, .4, { autoAlpha: 1 } );
//		}
		
		public function onTabClicked(which:Tab):void
		{
			selectedTab = which;
		}
		
		override public function toString():String
		{
			return "[TabPanel id: " + name + "]";
		}
		
		public function get selectedTab():Tab
		{
			return _selectedTab;
		}
		
		public function set selectedTab(val:Tab):void
		{
			if (_selectedTab) 
			{ 
				_selectedTab.selected = false;
				hideCopy();
			}
			_selectedTab = val;
			_selectedTab.selected = true;
			if (border) { border.gotoAndStop(val.index); }
			selectedSender.dispatch(val); 
			paginator.count = uint(pageData..tab[selectedTab.index-1]..images.image.length());
		}
		
		public function hideCopy():void
		{
			TweenMax.to(copyHolder, .5, { delay: .15, autoAlpha: 0 } );
		}
		
		private function adjustText():void
		{
			if (body) { body.y = headline.y + headline.height + 20; }
		}
		
		public function hide():void
		{
			TweenMax.to(this, .5, { delay: .1, autoAlpha: 0 } );
			TweenMax.to(this, .5, { x: 1400, ease: Circ.easeIn } );
			paginator.stopTimer();
		}
		
		public function show():void
		{
			TweenMax.to(this, .5, { delay: .5, x:749, ease: Circ.easeOut } );
			TweenMax.to(this, .5, { delay: .75, autoAlpha: 1 } );
		}
	}
}