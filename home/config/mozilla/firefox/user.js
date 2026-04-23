// GFX rendering

// WebRender Layer Compositor which limits what needs updating on the screen
// when something moves or changes
user_pref("gfx.webrender.layer-compositor", true);
user_pref("media.wmf.zero-copy-nv12-textures-force-enabled", true);

// Tracking protection

// Enable Enhanced Tracking Protection
user_pref("browser.contentblocking.category", "strict");

// Remove temp files opened from non-PB windows with an external application
user_pref("browser.download.start_downloads_in_tmp_dir", true);

// Disable UITour backend
user_pref("browser.uitour.enabled", false);

// Tell websites not to sell or share your data
user_pref("privacy.globalprivacycontrol.enabled", true);

// OSCP & HPKP (HTTP Public Key Pinning)

// Disable OCSP fetching to confirm current validity of certificates
user_pref("security.OCSP.enabled", 0);

// HTTP Public Key Pinning (HPKP)
user_pref("security.cert_pinning.enforcement_level", 2);

// Disable referrer and storage access for resources injected by content scripts
user_pref("privacy.antitracking.isolateContentScriptResources", true);

// Disable CSP Level 2 Reporting
user_pref("security.csp.reporting.enabled", false);

// SSL and TLS

// Display warning on the padlock for "broken security"
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);

// Display advanced information on Insecure Connection warning pages
user_pref("browser.xul.error_pages.expert_bad_cert", true);

// Disable 0-RTT (round-trip time) to improve TLS 1.3 security
user_pref("security.tls.enable_0rtt_data", false);

// Disk avoidance

// Disable disk cache
user_pref("browser.cache.disk.enable", false);

// Prevent media cache from writing to disk in Private Browsing
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);

// Increase the size of media memory cache
user_pref("media.memory_cache_max_size", 65536);

// Minimum interval (in ms) between session save operations
user_pref("browser.sessionstore.interval", 60000);

// History

// Set History section to show all options
user_pref("privacy.history.custom", true);

// Speculative loading

// Reduce any potential speculative connections when hovering over new tab
// thumbnails or starting a URL bar search
user_pref("network.http.speculative-parallel-limit", 0);

// Disable DNS prefetching for HTMLLinkElement <link rel="dns-prefetch">
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// Disable preconnection to the autocomplete URL in the address bar, bookmarks
// and history
user_pref("browser.urlbar.speculativeConnect.enabled", false);
user_pref("browser.places.speculativeConnect.enabled", false);

// Disable link prefetching <link rel="prefetch">
user_pref("network.prefetch-next", false);

// Search and URL bar

// Trim HTTPS from the URL bar
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);

// Disable search suggestions
user_pref("browser.search.suggest.enabled", false);

// Disable search and form history
user_pref("browser.formfill.enable", false);

// Enforce Punycode for Internationalized Domain Names to eliminate possible
// spoofing
user_pref("network.IDN_show_punycode", true);

// HTTPS-only mode

// Enable HTTPS-only everywhere
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.security.https_only_mode_ever_enabled_pbm", true);

// Offer suggestion for HTTPS site when available
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

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

// Extensions

// Skip 3rd party panel when installing recommended addons
user_pref("extensions.postDownloadThirdPartyPrompt", false);

// Headers & referers

// Control the amount of cross-origin information to send
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// Containers

// Enable containers and its UI setting
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

// Various

// Disallow PDFs to load javascript
user_pref("pdfjs.enableScripting", false);

// Mozilla

// Prevent accessibility services from accessing your browser
user_pref("accessibility.force_disabled", 1);

// Use alternative geolocation service instead of Google
user_pref("geo.provider.network.url", "https://beacondb.net/v1/geolocate");

// Disable metadata caching for installed add-ons
user_pref("extensions.getAddons.cache.enabled", false);

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

// Disable daily active users
user_pref("datareporting.usage.uploadEnabled", false);

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

// Mozilla UI

// Disable about:addons' recommendations pane (uses Google Analytics)
user_pref("extensions.getAddons.showPane", false);

// Disable recommendations in about:addons' Extensions and Themes panes
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Disable Firefox from asking to set as the default browser
user_pref("browser.shell.checkDefaultBrowser", false);

// Disable Extension Recommendations (CFR: "Contextual Feature Recommender")
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// Hide "More from Mozilla" in Settings
user_pref("browser.preferences.moreFromMozilla", false);

// Disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);

// Disable intro screens
user_pref("browser.aboutwelcome.enabled", false);

// Enable new profile switcher
user_pref("browser.profiles.enabled", true);

// Theme adjustments

// Enable Firefox to use userChome, userContent, etc.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Prevent private windows being separate from normal windows in taskbar
// (Windows only)
user_pref("browser.privateWindowSeparation.enabled", false);

// AI

// Disable AI features
user_pref("browser.ai.control.default", "blocked");
user_pref("browser.ml.enable", false);
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("browser.tabs.groups.smart.enabled", false);

// Translations

// Do not offer translations for Polish language
user_pref("browser.translations.neverTranslateLanguages", "pl");

// Font appearance

// Smoother font
user_pref("gfx.webrender.quality.force-subpixel-aa-where-possible", true);

// Use DirectWrite everywhere like Chrome (Windows only)
user_pref("gfx.font_rendering.cleartype_params.rendering_mode", 5);
user_pref("gfx.font_rendering.cleartype_params.cleartype_level", 100);
user_pref("gfx.font_rendering.directwrite.use_gdi_table_loading", false);

// URL bar

// Disable urlbar trending search suggestions
user_pref("browser.urlbar.trending.featureGate", false);

// Disable recent searches
user_pref("browser.urlbar.recentsearches.featureGate", false);

// New tab page

// Resume the previous Firefox session
user_pref("browser.startup.page", 3);

// Disable Shortcuts from Home page
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// Disable Sponsored Shortcuts from Home page
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Disable recent pages, bookmarks and downloads
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);

// Disable weather widget in Home page
user_pref("browser.newtabpage.activity-stream.showWeather", false);

// Disable Recommended by Pocket in Home page
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);

// Clear default topsites
user_pref("browser.newtabpage.activity-stream.default.sites", "");

// Always show bookmarks
user_pref("browser.toolbars.bookmarks.visibility", "always");

// Downloads

// Disable adding downloads to the system's "recent documents" list
user_pref("browser.download.manager.addToRecentDocs", false);

// PDF

// Open PDFs inline
user_pref("browser.download.open_pdf_attachments_inline", true);

// Always load PDF sidebar
user_pref("pdfjs.sidebarViewOnLoad", 2);

// DOM (Document Object Model)

// Prevent scripts from moving and resizing open windows
user_pref("dom.disable_window_move_resize", true);

// Tab behavior

// Leave Bookmarks Menu open when selecting a site
user_pref("browser.bookmarks.openInTabClosesMenu", false);

// Restore "View Image Info" on right-click
user_pref("browser.menu.showViewImageInfo", true);

// Show all matches in Findbar
user_pref("findbar.highlightAll", true);

// Leave the browser window open even after you close the last tab
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Keyboard and shortcuts

// Hide frequent sites on right-click of taskbar icon (Windows only)
user_pref("browser.taskbar.lists.frequent.enabled", false);

// Scrolling

// Smooth scrolling
user_pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS", 12);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant", 600);
user_pref("general.smoothScroll.msdPhysics.regularSpringConstant", 650);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS", 25);
user_pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio", "2");
user_pref("general.smoothScroll.msdPhysics.slowdownSpringConstant", 250);
user_pref("general.smoothScroll.currentVelocityWeighting", "1");
user_pref("general.smoothScroll.stopDecelerationWeighting", "1");
user_pref("mousewheel.default.delta_multiplier_y", 300);

// Sidebar

// Show sidebar
user_pref("sidebar.revamp", true);
user_pref("sidebar.verticalTabs", true);

// Scrolling

// Activate autoscroll
user_pref("general.autoScroll", true);
