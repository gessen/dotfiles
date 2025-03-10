// GFX rendering

// Enable WebRender plus additional features
user_pref("gfx.webrender.all", true);
user_pref("gfx.webrender.compositor", true);
user_pref("gfx.webrender.precache-shaders", true);

// Use GPU-accelerated Canvas2D with more memory
user_pref("gfx.canvas.accelerated.cache-size", 512);
user_pref("gfx.content.skia-font-cache-size", 20);

// Enable hardware acceleration (Linux only)
user_pref("media.ffmpeg.vaapi.enabled", true);

// Disk cache

// Disable disk cache
user_pref("browser.cache.disk.enable", false);

// Media cache

// Increase the size of media memory cache
user_pref("media.memory_cache_max_size", 65536);

// Image cache

// Increase the chunk size for calls to the image decoders
user_pref("image.mem.decode_bytes_at_a_time", 32768);

// Network

// Increase the absolute number of HTTP connections
user_pref("network.http.max-connections", 1800);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.http.max-urgent-start-excessive-connections-per-host", 5);

// Increase TLS token caching
user_pref("network.ssl_tokens_cache_capacity", 10240);

// Speculative loading

// Disable DNS prefetching for HTMLLinkElement <link rel="dns-prefetch">
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// Disable DNS prefetching for HTMLAnchorElement (speculative DNS)
user_pref("dom.prefetch_dns_for_anchor_http_document", false);
user_pref("dom.prefetch_dns_for_anchor_https_document", false);

// Disable link prefetching <link rel="prefetch">
user_pref("network.prefetch-next", false);

// Disable Network Predictor that trains and uses Firefox's algorithm to preload
// page resource by tracking past page resources
user_pref("network.predictor.enabled", false);

// Experimental

// Enable CSS Masonry Layout
user_pref("layout.css.grid-template-masonry-value.enabled", true);

// Enable HTML Sanitizer API
user_pref("dom.security.sanitizer.enabled", true);

// Tracking protection

// Enable Enhanced Tracking Protection
user_pref("browser.contentblocking.category", "strict");

// Allow embedded tweets, Instagram and Reddit posts, and TikTok embeds
user_pref("urlclassifier.trackingSkipURLs", "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com");
user_pref("urlclassifier.features.socialtracking.skipURLs", "*.instagram.com, *.twitter.com, *.twimg.com");

// Remove temp files opened from non-PB windows with an external application
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);

// Disable UITour backend
user_pref("browser.uitour.enabled", false);

// Tell websites not to sell or share your data
user_pref("privacy.globalprivacycontrol.enabled", true);

// OSCP & HPKP (HTTP Public Key Pinning)

// Disable OCSP fetching to confirm current validity of certificates
user_pref("security.OCSP.enabled", 0);

// Enable CRLite which covers valid certs, and doesn't fall back to OCSP in
// mode 2.
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

// HTTP Public Key Pinning (HPKP)
user_pref("security.cert_pinning.enforcement_level", 2);

// SSL and TLS

// Display warning on the padlock for "broken security"
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);

// Display advanced information on Insecure Connection warning pages
user_pref("browser.xul.error_pages.expert_bad_cert", true);

// Disable 0-RTT (round-trip time) to improve TLS 1.3 security
user_pref("security.tls.enable_0rtt_data", false);

// Disk avoidance

// Prevent media cache from writing to disk in Private Browsing
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);

// Minimum interval (in ms) between session save operations
user_pref("browser.sessionstore.interval", 60000);

// Store extra session data when crashing or restarting to install updates
user_pref("browser.sessionstore.privacy_level", 2);

// History

// Set History section to show all options
user_pref("privacy.history.custom", true);

// Disable search and form history
user_pref("browser.formfill.enable", false);

// URL bar

// Trim HTTPS from the URL bar
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);

// Display "Not Secure" text on HTTP sites
user_pref("security.insecure_connection_text.enabled", true);
user_pref("security.insecure_connection_text.pbmode.enabled", true);

// Disable search suggestions
user_pref("browser.search.suggest.enabled", false);

// Enforce Punycode for Internationalized Domain Names to eliminate possible
// spoofing
user_pref("network.IDN_show_punycode", true);

// Enable HTTPS-only everywhere
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.security.https_only_mode_ever_enabled_pbm", true);

// Passwords

// Disable auto-filling username & password form fields
user_pref("signon.autofillForms", false);

// Disable formless login capture for Password Manager
user_pref("signon.formlessCapture.enabled", false);

// Disable capturing credentials in Private Browsing
user_pref("signon.privateBrowsingCapture.enabled", false);

// Do not suggest Firefox Relay email masks to protect your email address
user_pref("signon.firefoxRelay.feature", "disabled");

// Limit (or disable) HTTP authentication credentials dialogs triggered by
// sub-resources
user_pref("network.auth.subresource-http-auth-allow", 1);

// Prevent password truncation when submitting form data
user_pref("editor.truncate_user_pastes", false);

// Address & credit card manager

// Disable form autofill
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Mixed content & cross-site

// Block insecure passive content (images) on HTTPS pages
user_pref("security.mixed_content.block_display_content", true);

// Disallow PDFs to load javascript
user_pref("pdfjs.enableScripting", false);

// Extensions

// Skip 3rd party panel when installing recommended addons
user_pref("extensions.postDownloadThirdPartyPrompt", false);

// Headers & referers

// Control the amount of cross-origin information to send
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// WebRTC

// Disable WebRTC (Web Real-Time Communication)
user_pref("media.peerconnection.enabled", false);

// Enable WebRTC Global Mute Toggles
user_pref("privacy.webrtc.globalMuteToggles", true);

// Mozilla

// Prevent accessibility services from accessing your browser
user_pref("accessibility.force_disabled", 1);

// Telemetry

// Disable new data submission
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Disable Health Reports
user_pref("datareporting.healthreport.uploadEnabled", false);

// Disable telemetry
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);

// Disable Telemetry Coverage
user_pref("toolkit.telemetry.coverage.opt-out", true);
user_pref("toolkit.coverage.opt-out", true);
user_pref("toolkit.coverage.endpoint.base", "");

// Disable Firefox Home (Activity Stream) telemetry
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// Experiments

// Disable Studies
user_pref("app.shield.optoutstudies.enabled", false);

// Disable Normandy/Shield
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

// Crash reports

// Disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

// Detection

// Disable Captive Portal detection
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);

// Disable Network Connectivity checks
user_pref("network.connectivity-service.enabled", false);

// Mozilla UI

// Disable about:addons' recommendations pane (uses Google Analytics)
user_pref("extensions.getAddons.showPane", false);

// Disable recommendations in about:addons' Extensions and Themes panes
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Disable Firefox from asking to set as the default browser
user_pref("browser.shell.checkDefaultBrowser", false);

// Hide "More from Mozilla" in Settings
user_pref("browser.preferences.moreFromMozilla", false);

// Disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);

// Disable into screens
user_pref("browser.aboutwelcome.enabled", false);

// Theme adjustments

// Enable Firefox to use userChome, userContent, etc.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Prevent private windows being separate from normal windows in taskbar
// (Windows only)
user_pref("browser.privateWindowSeparation.enabled", false);

// Always use XDG portals for file pickers which will make it use KDE's file
// picker insted of GTK one
user_pref("widget.use-xdg-desktop-portal.file-picker", 1);

// Translations

// Do not offer translations for Polish language
user_pref("browser.translations.neverTranslateLanguages", "pl");

// Font appearance

// Smoother font
user_pref("gfx.webrender.quality.force-subpixel-aa-where-possible", true);

// Use DirectWrite everywhere like Chrome (Windows only)
user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
user_pref("gfx.font_rendering.cleartype_params.force_gdi_classic_for_families", "");
user_pref("gfx.font_rendering.cleartype_params.force_gdi_classic_max_size", 6);
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);

// Use macOS Appearance Panel text smoothing setting when rendering text (macOS
// only)
user_pref("gfx.use_text_smoothing_setting", true);

// URL bar

// Suggest additional options
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);

// Disable urlbar trending search suggestions
user_pref("browser.urlbar.trending.featureGate", false);

// Disable recent searches
user_pref("browser.urlbar.recentsearches.featureGate", false);

// New windows and tabs

// Resume the previous Firefox session
user_pref("browser.startup.page", 3);

// Disable Shortcuts from Home page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// Disable Sponsored Shortcuts from Home page
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Disable recent pages, bookmarks, downloads and Pocket
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);

// Disable weather widget in Home page
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// Disable Recommended by Pocket in Home page
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Clear default topsites
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// Always show bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Pocket

// Disable built-in Pocket extension
user_pref("extensions.pocket.api"," ");
user_pref("extensions.pocket.enabled", false);
user_pref("extensions.pocket.oAuthConsumerKey", " ");
user_pref("extensions.pocket.showHome", false);

// Downloads

// Disable adding downloads to the system's "recent documents" list
user_pref("browser.download.manager.addToRecentDocs", false);

// PDF

// Open PDFs inline
user_pref("browser.download.open_pdf_attachments_inline", true);

// Always load PDF sidebar
user_pref("pdfjs.sidebarViewOnLoad", 2);

// Tab behavior

// Force all new windows opened by JavaScript into tabs
user_pref("browser.link.open_newwindow.restriction", 0);

// Leave Bookmarks Menu open when selecting a site
user_pref("browser.bookmarks.openInTabClosesMenu", false);

// Restore "View Image Info" on right-click
user_pref("browser.menu.showViewImageInfo", true);

// Show all matches in Findbar
user_pref("findbar.highlightAll", true);

// Prevent scripts from moving and resizing open windows
user_pref("dom.disable_window_move_resize", true);

// Leave the browser window open even after you close the last tab
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Show sidebar
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);

// Enable tabs groups
user_pref("browser.tabs.groups.enabled", true);

// Keyboard and shortcuts

// Hide frequent sites on right-click of taskbar icon (Windows only)
user_pref("browser.taskbar.lists.frequent.enabled", false);

// Scrolling

// Activate autoscroll
user_pref("general.autoScroll", true);

// Smooth scrolling
user_pref("general.smoothScroll.currentVelocityWeighting", "1");
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
