//

// Does not close the browser with the last tab
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Load userChrome.css
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Increases pixels per px
user_pref("layout.css.devPixelsPerPx", "1.125");

// Isolates all browser identifier sources
user_pref("privacy.firstparty.isolate", true);

// Max number of tabs to undo
user_pref("browser.sessionstore.max_tabs_undo", 10);

// WebRTC
user_pref("media.peerconnection.enabled", false);

// Speculative URLs
user_pref("browser.urlbar.speculativeConnect.enabled", true);

// Disables that websites can get notifications if you copy, paste, or cut something
user_pref("dom.event.clipboardevents.enabled", false);

// Disables tracking of the microphone and camera status
user_pref("media.navigator.enabled", false);

// Allows websites to track the battery status
user_pref("dom.battery.enabled", false);

// Health reports
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.healthreport.about.reportUrl", "");
user_pref("datareporting.healthreport.documentServerURI", ""); // Hidden option
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
user_pref("browser.tabs.crashReporting.sendReport", false);
user_pref("browser.tabs.crashReporting.requestEmail", false);
user_pref("browser.tabs.crashReporting.includeURL", false);
user_pref("browser.tabs.crashReporting.emailMe", false);
user_pref("dom.ipc.plugins.flash.subprocess.crashreporter.enabled", false);
user_pref("dom.ipc.plugins.reportCrashURL", false);

// Telemetry
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.cachedClientID", "");
user_pref("toolkit.telemetry.server", "");

// Telemetry experiments
user_pref("experiments.enabled", false);
user_pref("experiments.activeExperiment", false);
user_pref("experiments.supported", false);
user_pref("experiments.manifest.uri", "");
user_pref("network.allow-experiments", false);

// Pocket
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.api", ""); // Hidden option
user_pref("extensions.pocket.oAuthConsumerKey", ""); // Hidden option
user_pref("extensions.pocket.site", ""); // Hidden option

// Suggested sites
user_pref("browser.newtabpage.enhanced", false);
user_pref("browser.newtabpage.introShown", true);
user_pref("browser.newtabpage.directory.ping", "");
user_pref("browser.newtabpage.directory.source", "");

// Safe browsing
user_pref("browser.safebrowsing.malware.enabled", false);
user_pref("browser.safebrowsing.phishing.enabled", false);
user_pref("browser.safebrowsing.downloads.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.enabled", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous", false);
user_pref("browser.safebrowsing.downloads.remote.block_dangerous_host", false);
user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);
user_pref("browser.safebrowsing.downloads.remote.url", "");

// Google SafeBrowsing update URLs
user_pref("browser.safebrowsing.provider.google.updateURL", "");
user_pref("browser.safebrowsing.provider.google.gethashURL", "");
user_pref("browser.safebrowsing.provider.google4.updateURL", "");
user_pref("browser.safebrowsing.provider.google4.gethashURL", "");

// Mozilla SafeBrowsing update URLs
user_pref("browser.safebrowsing.provider.mozilla.updateURL", "");
user_pref("browser.safebrowsing.provider.mozilla.gethashURL", "");

// SafeBrowsing reporting URLs
user_pref("browser.safebrowsing.provider.google.reportURL", "");
user_pref("browser.safebrowsing.provider.google4.reportURL", "");
user_pref("browser.safebrowsing.reportMalwareMistakeURL", "");
user_pref("browser.safebrowsing.reportPhishMistakeURL", "");
user_pref("browser.safebrowsing.reportPhishURL", "");

// Heartbeat
user_pref("browser.selfsupport.enabled", false); // Hidden option
user_pref("browser.selfsupport.url", "");

// WebIDE
user_pref("devtools.webide.enabled", false);
user_pref("devtools.webide.autoinstallADBHelper", false);
user_pref("devtools.webide.autoinstallFxdtAdapters", false);

// Remote debugging
user_pref("devtools.debugger.remote-enabled", false);

// Extension updates
user_pref("extensions.update.enabled", true);

// Extension block list
user_pref("extensions.blocklist.enabled", true);
user_pref("services.blocklist.update_enabled", true);
user_pref("extensions.blocklist.url", "https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/");

// Extension metadata update
user_pref("extensions.getAddons.cache.enabled", false);

// Click to play
user_pref("plugins.click_to_play", true);

// Flash
user_pref("plugin.state.flash", 0);

// Java
user_pref("plugin.state.java", 0);

// Gnome Shell integration
user_pref("plugin.state.libgnome-shell-browser-plugin", 0); // Not found, probably only available if using Gnome Shell

// TLS versions
user_pref("security.tls.version.min", 1);
user_pref("security.tls.version.max", 4);

// TLS version fallback
user_pref("security.tls.version.fallback-limit", 3);

// Session tickets
user_pref("security.ssl.disable_session_identifiers", true); // Hidden option

// OCSP
user_pref("security.OCSP.enabled", 1);

// OCSP stapling
user_pref("security.ssl.enable_ocsp_stapling", true);

//
user_pref("security.cert_pinning.enforcement_level", 2);

// SSL error reporting
user_pref("security.ssl.errorReporting.enabled", false);
user_pref("security.ssl.errorReporting.automatic", false);
user_pref("security.ssl.errorReporting.url", "");

// disable 1024-bit dh primes
user_pref("security.ssl3.dhe_rsa_aes_128_sha", false);
user_pref("security.ssl3.dhe_rsa_aes_256_sha", false);

// RC4 fallback
user_pref("security.tls.unrestricted_rc4_fallback", false);

// Clean on shutdown
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.sanitize.timeSpan", 0);

// Clean categories on shutdown
user_pref("privacy.clearOnShutdown.cache", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.downloads", false);
user_pref("privacy.clearOnShutdown.formdata", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.offlineApps", false);
user_pref("privacy.clearOnShutdown.passwords", false);
user_pref("privacy.clearOnShutdown.sessions", false);
user_pref("privacy.clearOnShutdown.siteSettings", false);
user_pref("privacy.clearOnShutdown.openWindows", false);

// Manual clean
user_pref("privacy.cpd.cache", true);
user_pref("privacy.cpd.cookies", true);
user_pref("privacy.cpd.downloads", false);
user_pref("privacy.cpd.formdata", false);
user_pref("privacy.cpd.history", false);
user_pref("privacy.cpd.offlineApps", false);
user_pref("privacy.cpd.passwords", false);
user_pref("privacy.cpd.sessions", false);
user_pref("privacy.cpd.siteSettings", false);
user_pref("privacy.cpd.openWindows", false);

// Private browsing mode
user_pref("browser.privatebrowsing.autostart", false);

// Offline cache
user_pref("browser.cache.offline.enable", false);

// Disk cache
user_pref("browser.cache.disk.enable", true);

// Memory cache
user_pref("browser.cache.memory.enable", false);

//
user_pref("browser.cache.disk_cache_ssl", false);

// Form autofill
user_pref("browser.formfill.enable", false);

// Extra session data
user_pref("browser.sessionstore.privacy_level", 0);

// History
user_pref("places.history.enabled", true);

//
user_pref("offline-apps.allow_by_default", false);

// Visited links
user_pref("layout.css.visited_links_enabled", false);

// Disables DNS user_prefetch
user_pref("network.dns.disablePrefetch", true);

// Blocks cookies from 3rd parties
user_pref("network.cookie.cookieBehavior", 4);

// Cookie lifetime (accept them normally)
user_pref("network.cookie.lifetimePolicy", 0);

//
user_pref("dom.flyweb.enabled", false);

//
user_pref("browser.uitour.enabled", false);

//
user_pref("privacy.donottrackheader.enabled", false);

//
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.pbmode.enabled", true);

// Block fingerprinting and cryptomining
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
user_pref("privacy.trackingprotection.cryptomining.enabled", true);

//
user_pref("browser.casting.enabled", false);

//
user_pref("privacy.userContext.enabled", false);

// Face detection
user_pref("camera.control.face_detection.enabled", false);

// Reading sensors
user_pref("device.sensors.enabled", false);

// Geo location
user_pref("geo.enabled", false);
user_pref("geo.wifi.uri", "");
user_pref("geo.wifi.logging.enabled", false); // Hidden option
user_pref("geo.wifi.xhr.timeout", 1);
user_pref("browser.search.geoip.url", "");
user_pref("browser.search.geoip.timeout", 1);
user_pref("browser.search.geoSpecificDefaults", false);
user_pref("browser.search.geoSpecificDefaults.url", "");

// Copy selected contents to clipboard
user_pref("clipboard.autocopy", false);

// Keyboard events
user_pref("dom.keyboardevent.code.enabled", false);

//
// user_pref("keyword.enabled", false);

//
user_pref("browser.urlbar.trimURLs", false);

//
user_pref("browser.fixup.alternate.enabled", false);

//
user_pref("dom.event.contextmenu.enabled", false);

//
user_pref("browser.ctrlTab.previews", true);

//
user_pref("security.insecure_password.ui.enabled", true);

//
user_pref("general.buildID.override", "20100101");

// Allow pages to choose their own fonts
user_pref("browser.display.use_document_fonts", 1);

// Social
user_pref("social.remote-install.enabled", false);
user_pref("social.share.activationPanelEnabled", false);
user_pref("social.toast-notifications.enabled", false);
user_pref("social.shareDirectory", "");
user_pref("social.whitelist", "");
user_pref("social.directories", "");
user_pref("social.sidebar.unload_timeout_ms", 1);

user_pref("signon.rememberSignons", true);

// try resolving DNS over SOCKS proxies (needed for Tor)

user_pref("network.proxy.socks_remote_dns", true);

// disable search suggestions
user_pref("browser.search.suggest.enabled", false);

// do not embed the `missing flash player` frame
user_pref("plugins.notifyMissingFlash", false);
