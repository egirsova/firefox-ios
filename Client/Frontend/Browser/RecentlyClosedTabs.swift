/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared

public protocol RecentlyClosedTabs {
    func addTab(url: NSURL?, title: String?, faviconURL: String?)
    func getData() -> [String:[String]]?
    func clearData()
    func count() -> Int
}

public class RecentlyClosedTabsStore: RecentlyClosedTabs {
    let prefs: Prefs

    public init(prefs: Prefs) {
        self.prefs = prefs
    }

    public func addTab(url: NSURL?, title: String?, faviconURL: String?) {
        guard var recentlyClosedTabs = prefs.dictionaryForKey("recentlyClosedTabs"),
            var urls = recentlyClosedTabs["urls"] as? [String],
            var titles = recentlyClosedTabs["titles"] as? [String],
            var faviconUrls = recentlyClosedTabs["faviconUrls"] as? [String] else {
                var recentlyClosedTabsDict = [String:[String]]()
                recentlyClosedTabsDict["urls"] = [url?.absoluteString ?? ""]
                recentlyClosedTabsDict["faviconUrls"] = [faviconURL ?? ""]
                recentlyClosedTabsDict["titles"] = [title ?? ""]
                prefs.setObject(recentlyClosedTabsDict, forKey: "recentlyClosedTabs")
                return
        }
        urls.insert(url?.absoluteString ?? "", atIndex: 0)
        titles.insert(title ?? "", atIndex: 0)
        faviconUrls.insert((faviconURL ?? ""), atIndex: 0)

        recentlyClosedTabs["urls"] = urls
        recentlyClosedTabs["titles"] = titles
        recentlyClosedTabs["faviconUrls"] = faviconUrls
        prefs.setObject(recentlyClosedTabs, forKey: "recentlyClosedTabs")
    }

    public func getData() -> [String:[String]]? {
        return prefs.dictionaryForKey("recentlyClosedTabs") as? [String:[String]]
    }

    public func clearData() {
        prefs.setObject(nil, forKey: "recentlyClosedTabs")
    }

    public func count() -> Int {
        return prefs.dictionaryForKey("recentlyClosedTabs")?["urls"]?.count ?? 0
    }
}

public class MockRecentlyClosedTabsStore: RecentlyClosedTabsStore {
}
