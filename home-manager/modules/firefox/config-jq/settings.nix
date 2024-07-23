let
  # The values below were discovered with the
  # ~/.mozilla/firefox/$PROFILE/user.js file and the about:config and
  # about:preferences pages.
  restorePreviousSessions = 3;
  compact = 3;
in {
  "general.smoothScroll" = false;
  "font.size.variable.x-western" = 15;
  "font.size.monospace.x-western" = 14;
  "font.minimum-size.x-western" = 14;
  "font.default.x-western" = "sans-serif";
  "browser.urlbar.suggest.topsites" = false;
  "browser.urlbar.suggest.quicksuggest" = false;
  "browser.urlbar.suggest.quicksuggest.sponsored" = false;
  "browser.urlbar.suggest.history" = false;
  "browser.urlbar.suggest.bookmark" = true;
  "browser.urlbar.placeholderName" = "DuckDuckGo";
  "browser.urlbar.placeholderName.private" = "DuckDuckGo";
  "browser.uidensity" = compact;
  "browser.toolbars.bookmarks.visibility" = "never";
  "browser.tabs.warnOnClose" = false;
  "browser.tabs.tabmanager.enabled" = false;
  "browser.tabs.loadBookmarksInBackground" = true;
  "browser.tabs.inTitlebar" = "1";
  "browser.tabs.firefox-view" = false;
  "browser.tabs.firefox-view-newIcon" = false;
  "browser.tabs.closeWindowWithLastTab" = true;
  "browser.startup.page" = restorePreviousSessions;
  "browser.startup.homepage" = "about:blank";
  "browser.startup.blankWindow" = false;
  "browser.sessionstore.warnOnQuit" = true;
  "browser.search.widget.inNavBar" = true;
  "browser.search.update" = false;
  "browser.search.suggest.enabled" = false;
  "browser.newtabpage.enhanced" = false;
  "browser.newtabpage.enabled" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSearch" = false;
  "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
  "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
  "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
  "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
  "browser.newtabpage.activity-stream.prerender" = false;
  "browser.newtabpage.activity-stream.migrationExpired" = true;
  "browser.newtabpage.activity-stream.feeds.topsites" = false;
  "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
  "browser.newtab.url" = "about:blank";
  "browser.formfill.enable" = true;
  "browser.download.always_ask_before_handling_new_types" = true;
  "browser.display.use_document_fonts" = 0;
  "browser.display.background_color" = "#9a9996";
  "browser.bookmarks.addedImportButton" = false;
  "browser.aboutwelcome.enabled" = false;
  "browser.aboutConfig.showWarning" = false;

  "extensions.activeThemeID" = "{703d1dec-5792-4715-aa4d-77405b9b10e4}";
  "extensions.formautofill.addresses.enabled" = false;
  "extensions.formautofill.creditCards.enabled" = false;
  "extensions.formautofill.heuristics.enabled" = false;
  "extensions.pocket.enabled" = false;
  "general.autoScroll" = true;
  "media.eme.enabled" = true;
  "privacy.clearOnShutdown.cookies" = false;
  "privacy.fingerprintingProtection" = true;

  # This Clears history when Firefox closes:
  # "privacy.sanitize.sanitizeOnShutdown" = true;

  "privacy.donottrackheader.enabled" = true;
  "privacy.globalprivacycontrol.enabled" = true;
  "privacy.globalprivacycontrol.functionality.enabled" = true;
  "privacy.globalprivacycontrol.was_ever_enabled" = true;
  "privacy.trackingprotection.enabled" = true;
  "privacy.trackingprotection.socialtracking.enabled" = true;
  "browser.contentblocking.category" = "custom";

  # Password management. Disabled because we will use an extrenal Password Manager instead.
  "signon.rememberSignons" = false;
  "signon.autofillForms" = false;
  "signon.management.page.breach-alerts.enabled" = false;

  # Needed for Firefox to apply the userChrome.css and userContent.css
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "dom.forms.autocomplete.formautofill" = true;
  "extensions.formautofill.addresses.supported" = "on";
  "extensions.formautofill.addresses.usage.hasEntry" = true;

  # Anti-telemetry
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  "browser.ping-centre.telemetry" = false;
  "datareporting.healthreport.uploadEnabled" = false;
  "datareporting.policy.dataSubmissionEnabled" = false;
  "datareporting.sessions.current.clean" = true;
  "devtools.onboarding.telemetry.logged" = false;
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;
  "toolkit.telemetry.hybridContent.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled " = false;
  "toolkit.telemetry.reportingpolicy.firstRun" = false;
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.updatePing.enabled" = false;
  "toolkit.telemetry.pioneer-new-studies-available" = false;
  "app.shield.optoutstudies.enabled" = false;
  "signon.firefoxRelay.feature" = "disabled";
  # Do not report what I download to Mozilla.
  "browser.safebrowsing.downloads.enabled" = false;
  "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
  "browser.safebrowsing.downloads.remote.block_uncommon" = false;

  # Tree Style Tab
  "extensions.treestyletab.autoCollapseExpandSubtreeOnAttach" = false;
  "extensions.treestyletab.autoCollapseExpandSubtreeOnSelect" = false;
  "extensions.treestyletab.insertNewChildAt" = 0;
  "extensions.treestyletab.show.context-item-reloadDescendantTabs" = true;
  "extensions.treestyletab.show.context-item-removeAllTabsButThisTree" = true;
  "extensions.treestyletab.show.context-item-removeDescendantTabs" = true;
}
