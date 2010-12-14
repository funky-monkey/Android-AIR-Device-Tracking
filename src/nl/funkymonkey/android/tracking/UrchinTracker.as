package nl.funkymonkey.android.tracking {

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * @author   Sidney de Koning - {sidney@funky-monkey.nl}
	 * @project  Device Tracking
	 * 	
	 * Copyright (c) 2010 Funky Monkey Studio, All Rights Reserved 
	 * 
	 * Urchin Tracker
	 * A way to use AIR for Android (for Android/ iPad / iPhone) in combination with Google Analytics to track pages/application screens without using Javascript but by directly calling Googles tracking pixel. 
	 * Included is a PHP file and an AS3 Class to make the calls. 
	 * 
	 * @usage
	 * 		// Setup tracking
	 * 		UrchinTracker.setApplicationName(DocumentClass.APPLICATION_NAME);
	 * 		UrchinTracker.setDomain("http://www.yourdomain.com");
	 * 		
	 * 		// Do actual tracking
	 * 		UrchinTracker.trackDevicePage(AnalyticsPageNames.HOME_PAGE);
	 * 		
	 * @see https://github.com/funky-monkey/Android-AIR-Device-Tracking
	 * 
	 */
	public class UrchinTracker {

		private static const BASE_URL : String = "tracking.php?";
		private static const PAGE_PARAM : String = "page=";
		private static const AMP : String = "&";
		private static const APP_PARAM : String = "appname=";
		//
		private static var _appName : String;
		private static var _domain : String;

		public function UrchinTracker() {
		}

		/** 
		 * setDomain
		 * @param value	: String - Domain name including trailing slash. i.e http://www.domain.ext/ so http://www.domain.ext is wrong 
		 */
		public static function setDomain(value : String) : void {
			_domain = value;
		}

		/** 
		 * setApplicationName
		 * @param value	: String - Set the application name to be tracked through urchin/google analytics
		 */
		public static function setApplicationName(value : String) : void {
			_appName = value;
		}

		/**
		 * trackPage
		 * Normal page tracking through urchin/google analytics
		 * @param page : String - The page you want to track
		 * @param args : String - If more arguments are passed they will be concatnated in this format arg1/arg2/arg3, and are passed as the page param.
		 */
		public static function trackPage(page : String, ...args) : void {
			if ( args.length > 1 ) {
				page += args.join("/");
			}
			if (ExternalInterface.available) {
				ExternalInterface.call("pageTracker._trackPageview", page);
			} else {
				// Do fallback is no ExternalInterface.
			}
		}

		/**
		 * trackDevicePage
		 * Device specific tracking through urchin/google analytics
		 * @param page : String - The page you want to track
		 * @param appName : String - The name of the application you want to track.
		 */
		public static function trackDevicePage(page : String) : void {
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			var request : URLRequest = new URLRequest(_domain + BASE_URL);

			var variables : URLVariables = new URLVariables();
			variables.page = page;
			variables.appname = _appName;

			request.data = variables;
			
			trace("LBi - " + _domain + BASE_URL + variables);

			try {
				loader.load(request);
			} catch (error : Error) {
				trace("LBi - Unable to load requested document.");
			}
		}

		private static function handleComplete(event : Event) : void {
			var loader : URLLoader = URLLoader(event.target);
			trace("LBi - handleComplete: " + loader.data);
		}

		private static function handleProgress(event : ProgressEvent) : void {
			// trace("handleProgress loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		private static function handleSecurityError(event : SecurityErrorEvent) : void {
			// trace("handleSecurityError: " + event);
		}

		private static function handleHTTPStatus(event : HTTPStatusEvent) : void {
			// trace("handleHTTPStatus: " + event);
		}

		private static function handleIOError(event : IOErrorEvent) : void {
			// trace("handleIOError: " + event);
		}

		public static function toString() : String {
			return "[UrchinTracker]";
		}
	}
}