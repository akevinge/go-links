function registerRedirects(linkServerURL, apiKey) {
    console.log(apiKey);
    chrome.declarativeNetRequest.updateDynamicRules({
        removeRuleIds: [1, 2, 3, 4, 5, 6, 7],
        addRules: [
            {
                id: 1,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        regexSubstitution: `${linkServerURL}/\\1?api_key=${apiKey}`,
                    },
                },
                condition: {
                    regexFilter: '^http://go/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 2,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        url: 'https://calendar.google.com',
                    },
                },
                condition: {
                    regexFilter: '^http://c/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 3,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        url: 'http://mail.google.com',
                    },
                },
                condition: {
                    regexFilter: '^http://m/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 4,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        regexSubstitution: 'https://github.com/\\1',
                    },
                },
                condition: {
                    regexFilter: '^http://gh/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 5,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        regexSubstitution:
                            'https://github.com/utdnebula/planner/\\1',
                    },
                },
                condition: {
                    regexFilter: '^http://p/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 6,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        url: 'https://drive.google.com',
                    },
                },
                condition: {
                    regexFilter: '^http://d/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
            {
                id: 7,
                priority: 1,
                action: {
                    type: 'redirect',
                    redirect: {
                        url: 'https://outlook.office365.com/mail',
                    },
                },
                condition: {
                    regexFilter: '^http://o/(.*)',
                    resourceTypes: ['main_frame'],
                },
            },
        ],
    });
}

chrome.storage.local.get(
    { linkServerURL: 'http://localhost:5000/go', linkServerAPIKey: '' },
    (items) => {
        registerRedirects(items.linkServerURL, items.linkServerAPIKey);
    },
);

chrome.storage.onChanged.addListener((changes) => {
    registerRedirects(
        changes.linkServerURL.newValue,
        changes.linkServerAPIKey.newValue || changes.linkServerAPIKey.oldValue,
    );
});
